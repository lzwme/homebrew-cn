cask "autofirma" do
  arch arm: "M1", intel: "x64"
  pkg_arch = on_arch_conditional arm: "aarch64", intel: "x64"

  version "1.8.4"
  sha256 arm:   "2ffbf235fe0ff77c72707c674a67d4ffb924c05eca5910c7478dc96069c900a9",
         intel: "a14b6203d597cd113a2f53d587d657320632011b29cea1fbeadfd663140bcbed"

  url "https:estaticos.redsara.escomunesautofirma#{version.major}#{version.minor}#{version.patch}AutoFirma_Mac_#{arch}.zip",
      verified: "estaticos.redsara.escomunesautofirma"
  name "AutoFirma"
  desc "Digital signature editor and validator"
  homepage "https:firmaelectronica.gob.esciudadanosdescargas"

  livecheck do
    url :homepage
    regex(Versión\s+v?(\d+(?:\.\d+)+)\s+para\s+MacOS\s+procesadores\s+#{arch}i)
    strategy :page_match do |page, regex|
      match = page.match(regex)
      next if match.blank?

      match[1]
    end
  end

  # See https:github.comHomebrewhomebrew-caskpull116137#issuecomment-998220031
  installer manual: "AutoFirma_#{version.dots_to_underscores}_#{pkg_arch}.pkg"

  # remove 'Autofirma ROOT' and '127.0.0.1' certificates from keychain (these were installed by pkg)
  uninstall_postflight do
    ["AutoFirma ROOT", "127.0.0.1"].each do |cert_name|
      stdout, * = system_command "usrbinsecurity",
                                 args: ["find-certificate", "-a", "-c", cert_name, "-Z"],
                                 sudo: true
      hashes = stdout.lines.grep(^SHA-256 hash:) { |l| l.split(":").second.strip }
      hashes.each do |h|
        system_command "usrbinsecurity",
                       args: ["delete-certificate", "-Z", h],
                       sudo: true
      end
    end
  end

  uninstall quit:    "es.gob.afirma",
            pkgutil: "es.gob.afirma",
            delete:  "ApplicationsAutoFirma.app"

  zap trash: [
    "~.afirma",
    "~LibraryApplication SupportAutoFirma",
    "~LibraryPreferenceses.gob.afirma.plist",
  ]
end