open Printf

(* Print do output final*)
let rec print_list = function 
    [] -> ()
    | e::l -> if String.length e != 0 then printf "%s\n" e ; print_list l
;;

(* Funcao auxiliar para colocar as strings no fim da lista *)
let rec insert_at_end l i =
  match l with
    [] -> [i]
  | h :: t -> h :: (insert_at_end t i)
;;
(* Funcao auxiliar para colocar os elementos da lista por ordem alfabetica*)
let rec sort = function
    | [] -> [];
    | x :: l -> insert x (sort l)
  and insert elem = function
    | [] -> [elem]
    | x :: l -> if elem < x then elem :: x :: l
        else x :: insert elem l
;;

let read_input () =

    (* char_num representa o tamanho maximo das palavras a serem geradas*)
    let char_num = Scanf.sscanf ( read_line () ) "%d " (fun a -> a ) in
    (* aux representa quantas producoes tem a gramatica*)
    let aux = Scanf.sscanf ( read_line () ) "%d " (fun a -> a ) in
    
    (* Funcao recursiva para ignorar os caracteres: '-', ' ', '>' *)
    let rec charlist x acc i  =
        if i == -1
        then
            acc
        else
            if not (List.mem x.[i] ['-'; ' '; '>'])
            then
                charlist x (x.[i] :: acc) (i - 1)
            else
                charlist x acc (i - 1)
    in

    (* Funcao recursiva para criar a lista da gramatica *)
    let rec lines i acc =
        if i == 0 then (char_num, List.rev acc)
        else
            let tuple =
                let s = read_line () in
                match (charlist s [] ((String.length s) - 1) ) with
                | letter :: tail -> ( letter, tail )
                | _ -> ( '!', [] )
            in
            lines (i - 1) (tuple :: acc)

    in
    lines aux []

(* Cria todas as hipoteses para se substituir, dada uma letra *)
let find_replacement base letter =
    let rec aux base letter acc =
        match base with
        | (y, yy) :: ys ->
            if y == letter
            then
                aux ys letter (yy :: acc)
            else
                aux ys letter acc
        | _ -> acc
    in
    aux base letter []


(* Funcao principal para a formacao de palavras*)
let form_words grammar start length history =

    (* final_word contem apenas caracteres minusculos *)
    let final_word x = List.for_all (fun x -> x > 'Z' ) x in

    (* garbage contem apenas caracteres maisculos*)
    let garbage x = List.for_all ( fun x -> x <= 'Z' ) x in
    
    (* Verificacao de letra minuscula *)
    let is_lower x = x >= 'a' in

    (* verifica se a palavra excedeu o tamanho maximo de minusculas
        tamanho: 2 (exemplo dado)
        aa - final
        aaa - final e nao valida
        aAAAA - não sabe o que fazer
    *)
    let overflow x =
        let rec overflow x acc =
            match x with
            | x :: xs ->
                if is_lower x
                then
                    overflow xs (acc + 1)
                else
                    overflow xs acc
            | _ -> acc
        in
        overflow x 0
    in

    (* A funcao split divide as palavras, por ex:
        aaaAAaaa -> aaa A Aaaa
    *)
    let split w =
        let rec split w start =
            match w with
            | x :: xs ->
                if is_lower x
                then
                    split xs (x::start)
                else
                    ( List.rev start, x, xs )
            | _ -> ( [], '!', [] )
        in
        split w []
    in

    (* A funcao expand utiliza a lista das expansoes.
       Se a expansao estiver vazia, ou seja, todas as
       palavras já foram enviadas, a funcao envia o acumulador.
       Nao podem existir palavras vazias ( _ ) *)
    let expand expansion start endl =
        let rec aux x start endl acc =
            match x with
            | x::xs ->
                (* Expansao vazia -> Inicio + fim -> é adicionada ao acumulador -> proxima iteracao *)
                if List.length x == 1 && List.hd x == '_'
                then
                    aux xs start endl ( ( start @ endl ) :: acc )
                (* No caso de nao ser vazia: inicio + expansao + fim -> é adicionada ao acumulador -> proxima iteracao *)
                else
                    aux xs start endl ( ( start @ x @ endl ) :: acc )
            | _ -> acc
        in
        aux expansion start endl []
    in

    let rec fw grammar state final length history =
        (* state: onde está a informacao *)
        match state with
        | x :: xs ->
            (* Verifica se a palavra existe na lista auxiliar history*)
            if List.exists ((=) x) history
            then
                fw grammar xs final length history
            else (
                (* se o overflow for superior ao tamanho maximo,
                   ou se a variavel garbage for True (existirem apenas 
                   letras maiusculas) && o tamanho da lista x for maior
                   que o tamanho maximo das palavras por gerar +1,
                   salta para outro estado *)
                if ( overflow x > length ) || ( garbage x && List.length x > length + 1)
                then
                    fw grammar xs final length (x :: history)
                else
                    if final_word x
                    then
                        (* Verifica se a palavra é repetida, 
                           proxima iteracao *)
                        if List.exists ((=) x) final
                        then
                            fw grammar xs final length (x:: history)
                        (* Adiciona o estado e passa para o proximo *)
                        else
                            fw grammar xs (x :: ['\n'] :: final) length (x:: history)
                    else
                        (* divide a palavra *)
                        let ( start, middle, endl ) = split x in
                        (* replacement, expand e adiciona as novas palavras no state *)
                        let expansion = find_replacement grammar middle in
                        fw grammar ( ( expand expansion start endl ) @ xs ) final length (x:: history)
            )
        | _ -> final
    in

    fw grammar start [] length history

let () = 
    let len, x = read_input () in 
    let yy = form_words x [['S']] len [] in

    let temp = ref "" in
    let final_list = ref [] in

    (* A funcao recursiva thingy_2 utiliza as sublistas
       encontradas pela funcao thingy e armazena na variavel
       temp os caracteres até encontrar um '\n'.
       Depois, concatena os caracteres da variavel temp em strings*)
    let rec thingy_2 myList = match myList with
        | [] -> ()
        | head::body ->
        begin(
            if (head <> '\n') then
            begin
                temp := !temp^(String.make 1 head) 
            end
        else
            begin
                final_list := insert_at_end !final_list !temp;
                temp := "" 
            end 
        );

    thingy_2 body
    end

    in

    (* A funcao recursiva thingy itera sobre as sublistas dentro da lista final_list *)
    let rec thingy myList = match myList with
    | [] -> ()
    | head::body -> thingy_2 head;thingy body

    in

    thingy yy;
    print_list (sort !final_list)