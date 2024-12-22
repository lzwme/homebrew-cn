cask "uniflash" do
  version "9.0.0.5086"
  sha256 "2f64efd6e56f98e7471d67379b313250b6331f616e75affb7e1e8f9e7aec2cec"

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