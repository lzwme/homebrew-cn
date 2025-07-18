class RandomizeLines < Formula
  desc "Reads and randomize lines from a file (or STDIN)"
  homepage "https://arthurdejong.org/rl/"
  url "https://arthurdejong.org/rl/rl-0.2.7.tar.gz"
  sha256 "1cfca23d6a14acd190c5a6261923757d20cb94861c9b2066991ec7a7cae33bc8"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?rl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8ec08636ac3e5aa68060b1f43a1bd6a5cad418f489a4bbc9b9554053aa06188e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "194a2a869a8ecdeab95baf1f6b5f9d5d13c12eba7b6acd1378817da3e01a9740"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c351e68f794607d01893bca67180a80b721b597260304eb258f3108227950f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6aa2233b5cb7b9dd6ca98f51a6afee212967af3a1dd5b5d27f4ef0a7359c7bd0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c107eea0fba80096a370db46e622320bdb9ea825b837280e46ad236b3a37bbd4"
    sha256 cellar: :any_skip_relocation, sonoma:         "10e538eab3c969a0253e4febea9ce1d45b015e7b388c31a818438f850cbb5144"
    sha256 cellar: :any_skip_relocation, ventura:        "489084bd61495369766199746c6a3f011fe598d5b17eb809c10e99c9cfec7526"
    sha256 cellar: :any_skip_relocation, monterey:       "7dd7d179e5ac4567f69860ca54a379be5424a0c5e6fd8f0088ce6c158a77c47f"
    sha256 cellar: :any_skip_relocation, big_sur:        "05b5f772ee8d86ef341e30e91194b0a4b0cdbe5d3e16c8e319ed5e74a901e806"
    sha256 cellar: :any_skip_relocation, catalina:       "ff6262e5a351158ca8a2b25b577a892fc4cf2b7f9a2330e9fec595970c81674d"
    sha256 cellar: :any_skip_relocation, mojave:         "58709789bd3fae27aaa79f0c5149fc613128bb01e50e3a5b5dbdc61fe2f1b8bf"
    sha256 cellar: :any_skip_relocation, high_sierra:    "2d539a346c5a41f2b20773d8373e61f91a5d7e5b72b6d6dde7bd7c99dae64b6e"
    sha256 cellar: :any_skip_relocation, sierra:         "19f42b1930e7a523778b18834c9615eb3c891ee490a1cb41a73f61bc47c336f6"
    sha256 cellar: :any_skip_relocation, el_capitan:     "e61c986a537a9f0c77b1382add72096e72f7447ef50ac8acc01320014681e691"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "764e49f56b35776d575f1c96474373185c667956751c0c3b829680038a32e9d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d3ca6029fbd900632e5f09b68c583b1f441cf1bb711041ab00d519ee8fd323a"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write <<~EOS
      1
      2
      4
    EOS

    system bin/"rl", "-c", "1", testpath/"test.txt"
  end
end