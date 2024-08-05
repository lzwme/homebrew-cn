class Iproute2mac < Formula
  include Language::Python::Shebang

  desc "CLI wrapper for basic network utilities on macOS - ip command"
  homepage "https:github.combronaiproute2mac"
  url "https:github.combronaiproute2macreleasesdownloadv1.5.1iproute2mac-1.5.1.tar.gz"
  sha256 "cf1359bcaa18b6ccc19d6cdd0562b008d2e9b8a47b33d9d5d35c342d26add11e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bfa30ce839b43206920409d5c1efbb3536af7ae4f651fae21b5dded9c6dfabf9"
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