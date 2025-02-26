cask "prince" do
  version "16"
  sha256 "26411806cd8ef0e45a3b26a20edca5e8a1b4b86ab2defbfcd0e472e77737b4aa"

  url "https:www.princexml.comdownloadprince-#{version}-macos.zip"
  name "Prince"
  desc "Convert HTML to PDF"
  homepage "https:www.princexml.com"

  livecheck do
    url "https:www.princexml.comdownload"
    regex(>\s*Prince\s+v?(\d+(?:\.\d+)*)i)
  end

  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}prince-#{version}-macosprince.wrapper.sh"
  binary shimscript, target: "prince"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      exec '#{staged_path}prince-#{version}-macoslibprincebinprince' --prefix '#{staged_path}prince-#{version}-macoslibprince' "$@"
    EOS
  end

  # No zap stanza required
end