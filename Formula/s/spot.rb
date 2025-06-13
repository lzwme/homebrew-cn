class Spot < Formula
  desc "Platform for LTL and ω-automata manipulation"
  homepage "https://spot.lre.epita.fr"
  url "https://www.lrde.epita.fr/dload/spot/spot-2.13.2.tar.gz"
  sha256 "a412b3bbaef950215a2f71870ee24f01d722338b657cad9839f39acff1841011"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.lrde.epita.fr/dload/spot/"
    regex(/href=.*?spot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c1e80e60d55171d6bbb2e77539bf176c69b13117a14183df4190865db59ec804"
    sha256 cellar: :any,                 arm64_sonoma:  "606766c88eaa7f1e8ba043ffaa8d15592450681c0de93e7643ed13e446b82a75"
    sha256 cellar: :any,                 arm64_ventura: "45d6b574632621612e033579399b8dc82018b31ec63592612413b2ecf752e034"
    sha256 cellar: :any,                 sonoma:        "7c844ba41875b353048dbe712853def57bcda67866fbaf7eadd2f8914baa439a"
    sha256 cellar: :any,                 ventura:       "0bed99e85e80b646ed3b1f92901788a6058625152e9a670737a61050f2d4be2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6794d96a6ea8343a647bb8edb2f7f6b336f9996f7aadd15241738a111e8614df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f70f9ff9c45fa1428b0539e6fcd0917025b2db18686bcb3a3de00af89c38829f"
  end

  depends_on "python@3.13" => :build

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
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