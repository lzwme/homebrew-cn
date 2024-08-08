class Iproute2mac < Formula
  include Language::Python::Shebang

  desc "CLI wrapper for basic network utilities on macOS - ip command"
  homepage "https:github.combronaiproute2mac"
  url "https:github.combronaiproute2macreleasesdownloadv1.5.2iproute2mac-1.5.2.tar.gz"
  sha256 "1e9874b0cb3a18c98dc80f234322f5924e361d80bfd4b6581fca7f9874bcad4f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "61aa3fa174d8fe048d9f39e6d162063bd43ab3d258b05126599fc1cebb55a6fc"
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