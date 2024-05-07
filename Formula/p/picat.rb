class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "http://picat-lang.org/"
  url "http://picat-lang.org/download/picat365_src.tar.gz"
  version "3.6.5"
  sha256 "27b5f003c96cfd95c3e1b54d8f8e43e10261eabd62484e1bb3d0f2a2f37df5f7"
  license "MPL-2.0"

  livecheck do
    url "http://picat-lang.org/download.html"
    regex(/>\s*?Released version v?(\d+(?:[.#]\d+)+)\s*?,/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b31b5a5941e3f5a4a68e1a3b43e4a8a0e4bac83f60610211f27f4970528f6d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "12cd4d89a784cc9ac86b912b15cc87b36cf22f6c0fdf41bf776d50f3162b6f94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd6f640e9336a16a8a3a081005b35a13a02faffd5b4a0972798e369a48269b77"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa6a16f417921722f27b98df060894f936db3c57088ef6d99465b7714326215d"
    sha256 cellar: :any_skip_relocation, ventura:        "8e6d455b1f1545031812862554177688084d99949d45980beb87b2805097d27b"
    sha256 cellar: :any_skip_relocation, monterey:       "6d31a463cfab0054405daa4d7196e4bad57b3c4557a732ee9e529cd5d44ce7b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bc368817c27483d337f9401f8930b67b0adab4f8cd4c6f89d011f0edacf3b15"
  end

  def install
    makefile = if OS.mac?
      "Makefile.mac64"
    else
      ENV.cxx11
      "Makefile.linux64"
    end
    system "make", "-C", "emu", "-f", makefile
    bin.install "emu/picat" => "picat"
    prefix.install "lib" => "pi_lib"
    doc.install Dir["doc/*"]
    pkgshare.install "exs"
  end

  test do
    output = shell_output("#{bin}/picat #{pkgshare}/exs/euler/p1.pi").chomp
    assert_equal "Sum of all the multiples of 3 or 5 below 1000 is 233168", output
  end
end