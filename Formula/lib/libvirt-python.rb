class LibvirtPython < Formula
  desc "Libvirt virtualization API python binding"
  homepage "https://www.libvirt.org/"
  url "https://download.libvirt.org/python/libvirt-python-10.3.0.tar.gz"
  sha256 "0333781ffef915d984f36a9b475ae8df6d01763883eefbd138d14c7591f51f2f"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.libvirt.org/python/"
    regex(/href=.*?libvirt-python[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "53af2567092284d86e7364207b3ff9ce4bafd33fb833215d32a3cf409f32669b"
    sha256 cellar: :any,                 arm64_ventura:  "3f31d0601ca005f0203102e494f8278f263921b89220d64d78f1ae27616c6b82"
    sha256 cellar: :any,                 arm64_monterey: "cfa79918837165506124226339a219c6fa084c422df1c28d20b683f4b52ed8c7"
    sha256 cellar: :any,                 sonoma:         "c0b483e75ecb6400cba5bf712e160950da9b8ed9d0250c286008e46a2fa4c94a"
    sha256 cellar: :any,                 ventura:        "841246f282bc7d1491e68f8293fcdc26ee32498d7af7ec71c6efb32029160eea"
    sha256 cellar: :any,                 monterey:       "8749a4eb50cd364ebd7b58b0e0605201c2e2b16c53873e538a719b3802396e8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfde7159587d0df1044e3e4110989ba7deab959b1e20ac5c3ac13e4a3b22d1c3"
  end

  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "libvirt"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args, "."
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