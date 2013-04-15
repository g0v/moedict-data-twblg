re = -> Object.keys(it).sort(-> &1.length - &0.length).join \|
const Consonants = {
    p:\ㄅ b:\ㆠ ph:\ㄆ m:\ㄇ
    t:\ㄉ th:\ㄊ n:\ㄋ l:\ㄌ
    k:\ㄍ g:\ㆣ kh:\ㄎ ng:\ㄫ h:\ㄏ
    tsi:\ㄐ ji:\ㆢ tshi:\ㄑ si:\ㄒ
    ts:\ㄗ j:\ㆡ tsh:\ㄘ s:\ㄙ
}
C = re Consonants

const Vowels = {
    a:\ㄚ ann:\ㆩ oo:\ㆦ onn:\ㆧ o:\ㄜ
    e:\ㆤ enn:\ㆥ ai:\ㄞ ainn:\ㆮ
    au:\ㄠ aunn:\ㆯ am:\ㆰ om:\ㆱ m:\ㆬ
    ong:\ㆲ ng:\ㆭ i:\ㄧ inn:\ㆪ u:\ㄨ unn:\ㆫ
    ing:\ㄧㄥ in:\ㄧㄣ
}
V = re Vowels

const Tones = {
    p:\ㆴ t:\ㆵ k:\ㆶ h:\ㆷ
    "\u0300":\˪ "\u0301":\ˋ "\u0302":\ˊ "\u0304":\˫
}
T = re Tones

require! unorm
trs2bpmf = -> unorm.nfd(it).replace(/[A-Za-z\u0300-\u0304]+/g ->
  tone = '　'
  it.=toLowerCase!
  it.=replace //^(#C)// -> Consonants[it]
  it.=replace //(#T)// -> tone := Tones[it]; ''
  it.=replace //(#V)//g -> Vowels[it]
  "#it#tone"
).replace(/[- ]/g '').replace(/　/g ' ')

console.log trs2bpmf "lí kóng ing-gí iā-sī kok-gí?" #你講英語也是國語？(from @gugod)
console.log trs2bpmf "Lín tshiâu hó-sè tsiah kā guá kóng kiat-kó" #恁撨好勢才共我講結果
