cask "jtool" do
  version :latest
  sha256 :no_check

  url "https://www.newosxbook.com/tools/jtool.tar"
  name "jtool"
  desc "Tool to help out reverse engineering, security researchers, and tweak developers"
  homepage "https://newosxbook.com/tools/jtool.html"

  disable! date: "2024-12-16", because: :discontinued

  binary "jtool"
  manpage "jtool.1"
end