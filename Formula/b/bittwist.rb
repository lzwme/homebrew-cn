class Bittwist < Formula
  desc "Libcap-based Ethernet packet generator"
  homepage "https://bittwist.sourceforge.io"
  url "https://downloads.sourceforge.net/project/bittwist/macOS/Bit-Twist%204.5/bittwist-macos-4.5.tar.gz"
  sha256 "2b77177019c639cc7926d5c5a1657172af3a401af40e0674da20f906c137a595"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c3789012c27808c08426f6af6ad4f961618ac13bdc33d04ecacbf3c66a9113a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e5c37bdee758f6c8fa53d56d5ca55f02a187300920e9d527305d8b615ad2384"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "41082c20c3be91bb305c1f0510a654cc4ce823947e06c3f3237efc749c5ad937"
    sha256 cellar: :any_skip_relocation, sonoma:        "efed4a8abfb5e5e5d19b798e63f66633b9276e6a45b40314137f9ecefa2be524"
    sha256 cellar: :any_skip_relocation, ventura:       "b4c8eeca9b24b93945bee6f99412c56fc1dc59aeca51bea07c0534089df13dc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2fe48ce1c71eed5f75316ae8d0abbac2c36ecdff1600acba4d030280c2451b0"
  end

  uses_from_macos "libpcap"

  def install
    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system bin/"bittwist", "-help"
    system bin/"bittwiste", "-help"
  end
end