class LibvirtPython < Formula
  desc "Libvirt virtualization API python binding"
  homepage "https://www.libvirt.org/"
  url "https://download.libvirt.org/python/libvirt_python-12.8.0.tar.gz"
  sha256 "ab24a102ebf99b913ddc3459031aa71a48b0b1cdbb0f423b4ea278052791ac8a"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.libvirt.org/python/"
    regex(/href=.*?libvirt[_-]python[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8988645a7a8cdefe56ce0744418b8e04b88b0dc1384349bce0787d706f1da416"
    sha256 cellar: :any, arm64_tahoe:       "ed46998070065fa67f6517c64633a22fbbd4eb09605f06673284114395322cbe"
    sha256 cellar: :any, arm64_sequoia:     "504614c98a38e53e0daf76e5aa524ad2618ec92ba29586ff46dafd6e87973674"
    sha256 cellar: :any, arm64_linux:       "878ef24a24c2fe50284b95d1a8d137605ca71485281967f97c5892de1d4bf1f1"
    sha256 cellar: :any, x86_64_linux:      "2384e4acb38fe6bdc4c3fcb7c3ec0bedf51ba1b8ac9be1bc27e05ad88f411bb9"
  end

  depends_on "pkgconf" => :build
  depends_on "libvirt"
  depends_on "python@3.14"

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
             <<~PYTHON
               import libvirt

               with libvirt.open('test:///default') as conn:
                   if libvirt.virGetLastError() is not None:
                       raise SystemError("Failed to open a test connection")
             PYTHON
    end
  end
end