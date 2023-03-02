cask "ovftool" do
  version "4.1.0"
  sha256 "20cd526b8447e9b049a7e46d6e0be9752821f56b80261c38fd161077b5ad1581"

  url "http://ftp.tucha13.net/pub/software/VMware-ovftool-4.1.0/VMware-ovftool-4.1.0-2459827-mac.x64.dmg",
      verified: "ftp.tucha13.net/pub/software/VMware-ovftool-4.1.0/"
  name "OVF Tool"
  desc "VMware OVF Tool"
  homepage "https://code.vmware.com/tool/ovf/4.1.0"

  pkg "VMWare OVF Tool.pkg", allow_untrusted: true
  binary "/Applications/VMWare OVF Tool/ovftool"

  uninstall pkgutil: "com.vmware.ovftool.application"
end