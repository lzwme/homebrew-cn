cask "gqrx" do
  version "2.17.6"

  on_ventura :or_older do
    arch arm: "x86_64", intel: "x86_64"

    sha256 "88c22615b1b75d159b8900dd0c0921bc019d78197ff9da11be36c75b460ab764"

    caveats do
      requires_rosetta
    end
  end
  on_sonoma :or_newer do
    arch arm: "arm64", intel: "x86_64"

    sha256 arm:   "4f907f27d1eccdb9747ff6a349494eac90946900d87ee53f5bc9f6841f295f48",
           intel: "88c22615b1b75d159b8900dd0c0921bc019d78197ff9da11be36c75b460ab764"
  end

  url "https:github.comgqrx-sdrgqrxreleasesdownloadv#{version}Gqrx-#{version}-#{arch}.dmg",
      verified: "github.comgqrx-sdrgqrx"
  name "Gqrx"
  desc "Software-defined radio receiver powered by GNU Radio and Qt"
  homepage "https:www.gqrx.dk"

  depends_on macos: ">= :ventura"

  app "Gqrx.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}gqrx.wrapper.sh"
  binary shimscript, target: "gqrx"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      '#{appdir}Gqrx.appContentsMacOSgqrx' "$@"
    EOS
  end

  zap trash: "~.configgqrx"
end