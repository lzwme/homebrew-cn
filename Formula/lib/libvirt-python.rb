class LibvirtPython < Formula
  desc "Libvirt virtualization API python binding"
  homepage "https://www.libvirt.org/"
  url "https://download.libvirt.org/python/libvirt-python-10.5.0.tar.gz"
  sha256 "785023500f58d3e8e829af98647d43eee97e517aacc9d9e7ded43594ea52d032"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.libvirt.org/python/"
    regex(/href=.*?libvirt-python[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0d5c099e6075a707f9de697742fe52f9bf27ab247ffb55e1b6cca26363440397"
    sha256 cellar: :any,                 arm64_ventura:  "0c9652751c63cea9d060efdf4f8ba9446f6d145279d3a8acfe932da4c8957adc"
    sha256 cellar: :any,                 arm64_monterey: "a7ca430cd8e1658fccb2322956c094dc08d11c0428d84d3618f086e6825285e4"
    sha256 cellar: :any,                 sonoma:         "a0878bd3342d215a3b93a324ff7e62d792cc872a51f67bfcc70cf9758e2f7679"
    sha256 cellar: :any,                 ventura:        "a1e7ed5751680ff33c1731981e36927e4091162e36de87886341e468c00f40a1"
    sha256 cellar: :any,                 monterey:       "a9220bda3f5f75dd3ecffc9d9ee43b0bf7df9791f2863e8d4aeb752fddc28174"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66f4ed0a119554f6347dd712e03977b9e0ee5d92e668ed4ba687e9383b9023b5"
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