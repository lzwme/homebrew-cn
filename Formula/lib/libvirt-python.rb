class LibvirtPython < Formula
  desc "Libvirt virtualization API python binding"
  homepage "https://www.libvirt.org/"
  url "https://download.libvirt.org/python/libvirt-python-11.1.0.tar.gz"
  sha256 "00efb9a781087668512d6a002eb9cd136e44ff8701ac6793cc13b6fdc6d9ef8f"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.libvirt.org/python/"
    regex(/href=.*?libvirt-python[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a00f9384a59af5ef7f1cd74e9f26722bfe3f1272bc44abf6025b3d2bb920fdfd"
    sha256 cellar: :any,                 arm64_sonoma:  "d430b4f583ff509fc0406fc440d4ace07136b3830cfeacbd76f60224ba941adc"
    sha256 cellar: :any,                 arm64_ventura: "cfaf7ebf4556bc5ba98f824a396577e5ac3237b0debbd36f56d4f0b1f9a57772"
    sha256 cellar: :any,                 sonoma:        "5ba66905d74d72bb27d16b344843e37b28f72e392783dc1cbff2327e0ea06254"
    sha256 cellar: :any,                 ventura:       "740c0ed273658db6c643c810765e2dd11232da68c3947a52706c619c52555ea1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb11f5e8890bb0f3bf6c23c6c7195ed93ace389e06e1f70083816f0a9b9f56c3"
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