class LibvirtPython < Formula
  desc "Libvirt virtualization API python binding"
  homepage "https://www.libvirt.org/"
  url "https://download.libvirt.org/python/libvirt-python-11.6.0.tar.gz"
  sha256 "cf6077eddf7e0d20d7193c48309d57cb8d63e2adc68cafb2cf8354ec3d807dd8"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.libvirt.org/python/"
    regex(/href=.*?libvirt-python[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9bdf9795e1f53db921de36ab7fe149b1cf6901f78aa22c6b055a50557ca9702e"
    sha256 cellar: :any,                 arm64_sonoma:  "0c327df378d8a01c574a8ead4b737ab2514bf543c022b7e095ac7e38f8e2ed4e"
    sha256 cellar: :any,                 arm64_ventura: "fd8b013c285b770350f930f2c15e262697cd992d334480edb97576ebd96352f6"
    sha256 cellar: :any,                 sonoma:        "c4ccf9ae0a124616e1c581589bdfe021c058c3cb4e2adca2eff0de82c40322fc"
    sha256 cellar: :any,                 ventura:       "7220176c70f8eab593cef49da4256ef6d9f5a8c90491b3984f9885e20aed228f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93d3cb9aedea89c694481054c052f7137a55f7a22b73e1a9ae7c0ff0667dc8a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8616c5eaab2f0244a7c4894b5f840f2659becb0fbc19d20a7955734913f97375"
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