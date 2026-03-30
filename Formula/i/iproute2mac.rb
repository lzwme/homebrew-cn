class Iproute2mac < Formula
  include Language::Python::Shebang

  desc "CLI wrapper for basic network utilities on macOS - ip command"
  homepage "https://github.com/brona/iproute2mac"
  url "https://ghfast.top/https://github.com/brona/iproute2mac/releases/download/v1.7.3/iproute2mac-1.7.3.tar.gz"
  sha256 "029d7674180e889b2db966cc17499e9f1f54670dd335ff619ee9e7a769b397c5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c26e24460d0b9ca268cc8879176c0b22cef1a61acf18efd87e309032356b1587"
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