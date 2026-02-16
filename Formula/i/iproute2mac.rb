class Iproute2mac < Formula
  include Language::Python::Shebang

  desc "CLI wrapper for basic network utilities on macOS - ip command"
  homepage "https://github.com/brona/iproute2mac"
  url "https://ghfast.top/https://github.com/brona/iproute2mac/releases/download/v1.7.0/iproute2mac-1.7.0.tar.gz"
  sha256 "48bd7b0a6e9a8015dde2cf30f54f42750ffb5ac2f60a47530c7c6205d23a257e"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bb881198c78b4833e6c02ef8c1d22e187292f1a34cbbf09b190bfb078f682f30"
  end

  depends_on :macos
  depends_on "python@3.14"

  def install
    libexec.install "src/iproute2mac.py"
    libexec.install "src/ip.py" => "ip"
    libexec.install "src/bridge.py" => "bridge"
    libexec.install "src/ss.py" => "ss"
    rewrite_shebang detected_python_shebang, libexec/"ip", libexec/"bridge", libexec/"iproute2mac.py", libexec/"ss"
    bin.write_exec_script (libexec/"ip"), (libexec/"bridge"), (libexec/"ss")
  end

  test do
    system "/sbin/ifconfig -v -a 2>/dev/null"
    system bin/"ip", "route"
    system bin/"ip", "address"
    system bin/"ip", "neigh"
    system bin/"bridge", "link"
    system bin/"ss"
  end
end