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
    a:\ㄚ an: \ㄢ ang: \ㄤ ann:\ㆩ oo:\ㆦ onn:\ㆧ o:\ㄜ
    e:\ㆤ enn:\ㆥ ai:\ㄞ ainn:\ㆮ
    au:\ㄠ aunn:\ㆯ am:\ㆰ om:\ㆱ m:\ㆬ
    ong:\ㆲ ng:\ㆭ i:\ㄧ inn:\ㆪ u:\ㄨ unn:\ㆫ
    ing:\ㄧㄥ in:\ㄧㄣ un:\ㄨㄣ
}
V = re Vowels

const Tones = {
    p:\ㆴ t:\ㆵ k:\ㆶ h:\ㆷ
    p$:\.ㆴ t$:\.ㆵ k$:\.ㆶ h$:\.ㆷ
    "\u0300":\˪ "\u0301":\ˋ
    "\u0302":\ˊ "\u0304":\˫
    "\u030d":\$
}

require! unorm
trs2bpmf = -> unorm.nfd(it).replace(/[A-Za-z\u0300-\u030d]+/g ->
  tone = ''
  it.=toLowerCase!
  it.=replace //([\u0300-\u0302\u0304\u030d])// -> tone := Tones[it]; ''
  it.=replace //^(tsh?|[sj])i// '$1ii'
  it.=replace //ok$// 'ook'
  it.=replace //^(#C)((?:#V)+[ptkh]?)$// -> Consonants[&1] + &2
  it.=replace //[ptkh]$// -> tone := Tones[it+tone]; ''
  it.=replace //(#V)//g -> Vowels[it]
  it + (tone || '\uFFFD')
).replace(/[- ]/g '').replace(/\uFFFD/g ' ')

# TODO: Tonal adjustment based on hyphenation: Ko-hiông => ㄍㄜ˫ㄏㄧㆲˊ, not ㄍㄜ ㄏㄧㆲˊ
# TODO: Diaeresis: kè-tsa̋u-kiánn: => ㄍㆤˋㄗㄚㄨ ㄍㄧㆩˋ, not ㄍㆤˋㄗㄠ ㄍㄧㆩˋ
