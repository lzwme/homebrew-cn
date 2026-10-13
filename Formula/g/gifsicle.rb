class Gifsicle < Formula
  desc "GIF image/animation creator/editor"
  homepage "https://www.lcdf.org/gifsicle/"
  url "https://www.lcdf.org/gifsicle/gifsicle-1.97.tar.gz"
  sha256 "17d98f305372e8c6c47c3fa7c75a9ebd9a8dea0b47c739d0b3be6c30a1c1da7a"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?gifsicle[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6beb9fdcf26ccd1a787913ec81fa54d22941b6ca4897d6b36346d10a63028123"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "68d013fc286c59a4bf3e3278019aef0fce9de2cceeee68e3849aa337b1a292a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2b70a92a797ea903eac7671e8e2e51d99c728205b127228bb3cdcf7a52f0bb70"
    sha256 cellar: :any,                 arm64_linux:       "5ac9d75933a972d72cee89563e0e8e52a06df298f96ada531b10e7ed05ed62e3"
    sha256 cellar: :any,                 x86_64_linux:      "c81594962a1fa63410da27146e0fe193f5c4d132d29326223166fea9c7340dfd"
  end

  head do
    url "https://github.com/kohler/gifsicle.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-gifview
    ]

    system "./bootstrap.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"gifsicle", "--info", test_fixtures("test.gif")
  end
end