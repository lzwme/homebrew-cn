class Iproute2mac < Formula
  include Language::Python::Shebang

  desc "CLI wrapper for basic network utilities on macOS - ip command"
  homepage "https:github.combronaiproute2mac"
  url "https:github.combronaiproute2macreleasesdownloadv1.5.3iproute2mac-1.5.3.tar.gz"
  sha256 "a5d790863b2ad92ff2e918908a82563898ee8165278ffa0b5e453437bd5ef9fb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fd4d7c95e88fb3699ad1a90463316af86c78f056040a25ed463f9dd7190ba6a2"
  end

  depends_on :macos
  depends_on "python@3.12"

  def install
    libexec.install "srciproute2mac.py"
    libexec.install "srcip.py" => "ip"
    libexec.install "srcbridge.py" => "bridge"
    rewrite_shebang detected_python_shebang, libexec"ip", libexec"bridge", libexec"iproute2mac.py"
    bin.write_exec_script (libexec"ip"), (libexec"bridge")
  end

  test do
    system "sbinifconfig -v -a 2>devnull"
    system bin"ip", "route"
    system bin"ip", "address"
    system bin"ip", "neigh"
    system bin"bridge", "link"
  end
end