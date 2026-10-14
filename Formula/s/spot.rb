class Spot < Formula
  desc "Platform for LTL and ω-automata manipulation"
  homepage "https://spot.lre.epita.fr"
  url "https://www.lrde.epita.fr/dload/spot/spot-2.16.tar.gz"
  sha256 "688463cb2fa393c51d9cf938fb01a716b91e4c8122aeb52fd116a3bbfddab869"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.lrde.epita.fr/dload/spot/"
    regex(/href=.*?spot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "44c4cd1901925b3aaa42c17c928528cd0a0efeb57707607ad228d67edf7d4f38"
    sha256 cellar: :any, arm64_tahoe:       "9d4b6c3e3c2f34a74f1292890cac6770fa8a1425e3e1b81f7b7c8f713d764a10"
    sha256 cellar: :any, arm64_sequoia:     "95b2bf75883848a0f59adf7835fec46ee89802f9e96b5d93e5debc4e6a32ec9f"
    sha256 cellar: :any, arm64_linux:       "f13aceacb89e7f668bf460cb2f95976f939ee8873047b666b7dd0c4a4d1a6b81"
    sha256 cellar: :any, x86_64_linux:      "91362a3597b0dd3108c13cf1912647aad3bbd8e13f5462d996dd46664017c6c8"
  end

  depends_on "python@3.15" => :build

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