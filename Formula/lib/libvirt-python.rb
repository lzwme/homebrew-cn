class LibvirtPython < Formula
  desc "Libvirt virtualization API python binding"
  homepage "https://www.libvirt.org/"
  url "https://download.libvirt.org/python/libvirt-python-10.7.0.tar.gz"
  sha256 "8fd4edcb3f3c23cadb4053096c941e026456b5a7b5a635c1cebad044143aba53"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.libvirt.org/python/"
    regex(/href=.*?libvirt-python[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a34013129c6d5cb58e395b70189b62843415417d85dfd77f0c80a2f19eff21a7"
    sha256 cellar: :any,                 arm64_ventura:  "784079ea3b09073ba47daa8ff4999ad661f8bbdfae702aae0b7970190dffdc85"
    sha256 cellar: :any,                 arm64_monterey: "5634a85e29aeace4f555d1895869764d3589af81cabcd778a2354f823cfcb0be"
    sha256 cellar: :any,                 sonoma:         "a064f4eda29c9f56301bcc59ac9dff2e6ab9bf93f1e3c665ab08ab784d8be22d"
    sha256 cellar: :any,                 ventura:        "bd0dfeb57b8ea5077660bb5604d7ec7bbd67a659cba0a021d103b1bd72be25f9"
    sha256 cellar: :any,                 monterey:       "00ff18f15f08861b1edb40975b6e0062e06c44ebe4097848989910231251068e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bf873fdd6ad76b18b5ebc4043bc596ed42c0e3d433fa10bba6a20a7f87a4091"
  end

  depends_on "pkg-config" => :build
  depends_on "libvirt"
  depends_on "python@3.12"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    end
  end

  test do
    system "python3.12", "-c",
           # language=Python
           <<~EOS
             import libvirt

             with libvirt.open('test:///default') as conn:
                 if libvirt.virGetLastError() is not None:
                     raise SystemError("Failed to open a test connection")
           EOS
  end
end