class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.3.3.tar.gz"
  sha256 "23190972e6bbea96fa6ef93de377d3a81ae98a90ca5606dc0bd0e934ea9fd305"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2854584e53b1b2d727a3e4db37bd04b72af286da39ac2b641203a1b9142bbecd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a46591df39e09d85610c072065c36cd8ce4b2e31be2b83f5e0f8d6bdb2f9375c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e340e5b89b0443c3b50f4481940e16de9c546a2feb4586c5b67018b22e593b6"
    sha256                               ventura:        "c902084f3bb5670383c7a51b87cf448ced03b679de8896dcbb57cd8b31a3abc1"
    sha256                               monterey:       "8e7d728410c79a443ffb7df12489da1a29dd19b9ce8dd825a96728a4284ca544"
    sha256                               big_sur:        "4257290376ba00f0b720995d701dfa5b17a24866942c93a570f77ec0122081da"
    sha256                               x86_64_linux:   "3f6f8770d7a2cd59b54e3cb255c7b18a1842e86011389de63f3e6244e9e6d20d"
  end

  on_linux do
    depends_on "libpq"
  end

  def install
    # Workaround for Xcode 14.3.
    ENV.append_to_cflags "-Wno-implicit-function-declaration"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"hello.alg"
    path.write <<~EOS
      print("Hello World")
    EOS

    assert_equal "Hello World", shell_output("#{bin}/a68g #{path}").strip
  end
end