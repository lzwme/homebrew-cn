cask "uniflash" do
  version "9.1.0.5175"
  sha256 "810e354a57be274abf31addf8390c5ecd4ddf5abc091f56f3199e2f041b5abd3"

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