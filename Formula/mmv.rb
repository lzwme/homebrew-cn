class Mmv < Formula
  desc "Move, copy, append, and link multiple files"
  homepage "https://github.com/rrthomas/mmv"
  url "https://ghproxy.com/https://github.com/rrthomas/mmv/releases/download/v2.5/mmv-2.5.tar.gz"
  sha256 "866d98cc87851c514a2459362cea233cf751e173136bcff61c15b39ca8a2f464"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5e535c7ebeb5991cb66783caaf4170a2dbc3878b81cfc9b990e5c19b830b52ad"
    sha256 cellar: :any,                 arm64_monterey: "b7e081ea1e5eacc29e224204ee9f7600b17263a9356856d744f8aa12089ecaa7"
    sha256 cellar: :any,                 arm64_big_sur:  "b5fd1da65bb1a4ddb55a64ea5c0d11f47a6efe5f3091025ff2bc550aea61e802"
    sha256 cellar: :any,                 ventura:        "10ef5bfc086bd7238ae351a5b1ab99921bf42330c8f38fe6fe1af8d8d76d5c33"
    sha256 cellar: :any,                 monterey:       "080db670b4b1375dbead8fab0adc7e8b26f8add64bc6e80132259320e5cb90b9"
    sha256 cellar: :any,                 big_sur:        "f961a58d82b516cff45f255665dc8368bf6eb6d4ca27b418b86c270bb133b1ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af43bc6ce832cd2d8934f6f85ae5cc909704a1e445bff01431d7995836dcd19c"
  end

  depends_on "pkg-config" => :build
  depends_on "bdw-gc"

  def install
    # Workaround for Xcode 14.3.
    ENV.append_to_cflags "-Wno-implicit-function-declaration"

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"a").write "1"
    (testpath/"b").write "2"

    assert_match "a -> b : old b would have to be deleted", shell_output("#{bin}/mmv -p a b 2>&1", 1)
    assert_predicate testpath/"a", :exist?
    assert_match "a -> b (*) : done", shell_output("#{bin}/mmv -d -v a b")
    refute_predicate testpath/"a", :exist?
    assert_equal "1", (testpath/"b").read

    assert_match "b -> c : done", shell_output("#{bin}/mmv -s -v b c")
    assert_predicate testpath/"b", :exist?
    assert_predicate testpath/"c", :symlink?
    assert_equal "1", (testpath/"c").read
  end
end