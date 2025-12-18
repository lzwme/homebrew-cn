class Spot < Formula
  desc "Platform for LTL and ω-automata manipulation"
  homepage "https://spot.lre.epita.fr"
  url "https://www.lrde.epita.fr/dload/spot/spot-2.14.4.tar.gz"
  sha256 "c8f168b32668a397656a47affb1ef2aebc1de891c30b6e0d04327e9106204666"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.lrde.epita.fr/dload/spot/"
    regex(/href=.*?spot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "01480a5ad630ce83dc1abc70848ea5a5f4e56cbcdc24bb1ca89208764a0095e3"
    sha256 cellar: :any,                 arm64_sequoia: "626e120c317771bfb7da95f884a8e63e1e80c758ed0218a00ba47c027506e4fb"
    sha256 cellar: :any,                 arm64_sonoma:  "aebf70e6c367d163828d3aea04c398f5383958e0cbb4f89482c66f6114d841aa"
    sha256 cellar: :any,                 sonoma:        "f968bcd1f8ebedd716c03cd261fcc72564136643778021f78052514b43e6db51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9efe389fcf9f67a2113e93628f0f4dce6657d8c292249023cb089e538231e9b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e817081f8e51828e3cfb447722ec1de29756b7d2d727282c6638d9f86ff236b"
  end

  depends_on "python@3.14" => :build

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    randltl_output = pipe_output("#{bin}/randltl -n20 a b c d", "")
    assert_match "Xb R ((Gb R c) W d)", randltl_output

    ltlcross_output = pipe_output("#{bin}/ltlcross '#{bin}/ltl2tgba -H -D %f >%O' " \
                                  "'#{bin}/ltl2tgba -s %f >%O' '#{bin}/ltl2tgba -DP %f >%O' 2>&1", randltl_output)
    assert_match "No problem detected", ltlcross_output
  end
end