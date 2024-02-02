class Ascii < Formula
  desc "List ASCII idiomatic names and octal/decimal code-point forms"
  homepage "http://www.catb.org/~esr/ascii/"
  url "http://www.catb.org/~esr/ascii/ascii-3.19.tar.gz"
  sha256 "f9da2efed82f245658f9561e5b756809e71eaf0e5a7735ac5beb924cdda9a560"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/ascii[._-]v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "580f8956e42c68a63496b3a0cf84bef4054c84c35a2e8914771df61e511b18c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71e8fcc5906e4ee8222296ea7b1cc43ec12646890c086ab033179dc9af55db78"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cc2bda5a534f431a87b48a2034c3870767802c9a4b5744f868105546f16b0a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f906b6d394320f5d43ce006e270607507fa9c2a3bd8a07bc981611e6235b3bb"
    sha256 cellar: :any_skip_relocation, ventura:        "91687c1ff03f1316ff8781b34cbccfdebd11ee76b5075f7a0ae8d06fb1acda5d"
    sha256 cellar: :any_skip_relocation, monterey:       "42182f24ca751492122dfcd070a185adaa46c6923cf686f6a91b78cc27097948"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a4fa5df04b0d070e67b50c2e4bd4c5d6e8b051d17ad9e64d766cabbc29c9f91"
  end

  head do
    url "https://gitlab.com/esr/ascii.git", branch: "master"
    depends_on "xmlto" => :build
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog" if build.head?
    bin.mkpath
    man1.mkpath
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "Official name: Line Feed", shell_output(bin/"ascii 0x0a")
  end
end