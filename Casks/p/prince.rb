cask "prince" do
  version "15.4.1"
  sha256 "08c5e76694bcc5914351a7d87d4aa9dde786c88d1fe8d2594c46d7b5fc66f626"

  url "https:www.princexml.comdownloadprince-#{version}-macos.zip"
  name "Prince"
  desc "Convert HTML to PDF"
  homepage "https:www.princexml.com"

  livecheck do
    url "https:www.princexml.comdownload"
    regex(>Prince v?(\d+(?:\.\d+)+)i)
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