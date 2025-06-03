class LibvirtPython < Formula
  desc "Libvirt virtualization API python binding"
  homepage "https://www.libvirt.org/"
  url "https://download.libvirt.org/python/libvirt-python-11.4.0.tar.gz"
  sha256 "7335de498e3fdb2c96f68ee4065d44ab0404b79923d6316819a4b5f963f80125"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.libvirt.org/python/"
    regex(/href=.*?libvirt-python[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8c9335398dcc5937717914221b2b2c9e3f1fac715c3a7dedac049486ed7f98b9"
    sha256 cellar: :any,                 arm64_sonoma:  "ca5249a614d63986a8261d2b0f3f071a11f69b210fd9e93a36cbc764ea01040a"
    sha256 cellar: :any,                 arm64_ventura: "046bf692453bb60daedbc252f0827da4c03e5780341e70a21cfc2407f807b662"
    sha256 cellar: :any,                 sonoma:        "db728e37eeca823dc777fa366438af59095cfd457b2a65f2c734e56d225b3aca"
    sha256 cellar: :any,                 ventura:       "2c5eccae0489bb3f88385941ed022316b2a75556c51b811b1cfc5ab98b97e276"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16f663b1f4d13f1d77cbb3b1e326dcd39dca841dba2ffa9a9125ff32fc4a7af0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c3316a9c8776a406797a5562c2320a44ab137ba985225f64e93d7672ff850e9"
  end

  depends_on "pkgconf" => :build
  depends_on "libvirt"
  depends_on "python@3.13"

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
    pythons.each do |python|
      system python, "-c",
             # language=Python
             <<~EOS
               import libvirt

               with libvirt.open('test:///default') as conn:
                   if libvirt.virGetLastError() is not None:
                       raise SystemError("Failed to open a test connection")
             EOS
    end
  end
end