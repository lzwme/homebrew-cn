class Iproute2mac < Formula
  include Language::Python::Shebang

  desc "CLI wrapper for basic network utilities on macOS - ip command"
  homepage "https:github.combronaiproute2mac"
  url "https:github.combronaiproute2macreleasesdownloadv1.5.4iproute2mac-1.5.4.tar.gz"
  sha256 "9548ed9ead114a3a7095890c51e0e5b1d8ea1dd955692400e19fb97f1b6ad015"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "231085d2b1c81ef0406d5f32239fe6edfb4f92e52ab0f3a4065221e318b2babc"
  end

  depends_on :macos
  depends_on "python@3.13"

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