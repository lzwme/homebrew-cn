cask "uniflash" do
  version "8.8.1.4983"
  sha256 "0f00957da1d5dd2e93fc6e2be5bc5e375cb32ad2e940cb5716e5a61470b567b8"

  url "https:dr-download.ti.comsoftware-developmentsoftware-programming-toolMD-QeJBJLj8gq#{version.major_minor_patch}uniflash_sl.#{version}.dmg"
  name "TI UniFlash"
  desc "Flash tool for microcontrollers"
  homepage "https:www.ti.comtoolUNIFLASH"

  livecheck do
    url :homepage
    regex(href=.*?uniflash_sl\.(\d+(?:\.\d+)+)\.dmgi)
  end

  installer script: {
    executable: "uniflash_sl.#{version}.appContentsMacOSinstallbuilder.sh",
    args:       ["--mode", "unattended", "--prefix", "ApplicationsTIUniFlash"],
  }
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}dslite"
  binary shimscript

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      exec 'ApplicationsTIUniFlashdslite.sh' "$@"
    EOS
  end

  uninstall script: {
    executable: "ApplicationsTIUniFlashuninstall.appContentsMacOSinstallbuilder.sh",
    args:       ["--mode", "unattended"],
    sudo:       true,
  }

  zap trash: [
        "~.tiuniflash",
        "~LibraryApplication SupportUniflash",
        "~LibraryCachesUniflash",
      ],
      rmdir: "~.ti"
end