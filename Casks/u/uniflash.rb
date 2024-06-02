cask "uniflash" do
  version "8.7.0.4818"
  sha256 "f8f118910fe17f9daa8d6ad7c1e14b08d50fbddbf55a44daa5bbf13df07c53d2"

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