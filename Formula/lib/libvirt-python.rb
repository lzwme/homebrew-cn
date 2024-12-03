class LibvirtPython < Formula
  desc "Libvirt virtualization API python binding"
  homepage "https://www.libvirt.org/"
  url "https://download.libvirt.org/python/libvirt-python-10.10.0.tar.gz"
  sha256 "8acf6dcfb33a03ed92f9440cb1a0b8d3fc53fb23bba2e76ceedeb8bfb5327557"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.libvirt.org/python/"
    regex(/href=.*?libvirt-python[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d4732af0d49ad175254aecb09ae10842fe509b263718ce7a4a7b19a7dc0af68d"
    sha256 cellar: :any,                 arm64_sonoma:  "c93c276b5850fe7fe560b9486b3ff4aa09311b77bf2e518f8b67fc76a50069b3"
    sha256 cellar: :any,                 arm64_ventura: "9081757506c85de03d4902c98680b98001208ff68d2f12f171e9aff1479191ce"
    sha256 cellar: :any,                 sonoma:        "dc48a7ee4240bb64366d1568df2065f321d45e5093cf9d4a4ec4a528defbc442"
    sha256 cellar: :any,                 ventura:       "4f611f7456f95facbea4aef6bf8921ddff590ab4b328b846ce99294c0b7d43c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f09696afb926a9f2f467d7dc512e41ed2e21afa1b8f199fc2a8a5759509f9a18"
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