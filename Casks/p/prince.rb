cask "prince" do
  version "15.4"
  sha256 "08552d090275627b3d35cf291b251459a1fb5433e555654d0d8e6db132e64bf0"

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