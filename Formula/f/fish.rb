class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://ghproxy.com/https://github.com/fish-shell/fish-shell/releases/download/3.6.3/fish-3.6.3.tar.xz"
  sha256 "55520128c8ef515908a3821423b430db9258527a6c6acb61c7cb95626b5a48d5"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  pour_bottle? only_if: :default_prefix

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0abdaa242d16da4102e8ec60bafccfc275146a86cfa7f121555f836d37dbbc4b"
    sha256 cellar: :any,                 arm64_ventura:  "440d15eb9224e4ca7463d92cb9e95e75cb426464954dd43d71c8f66da71e6b29"
    sha256 cellar: :any,                 arm64_monterey: "90d8c90244fcb78a6cfa18756a64c9904a76f16866ee95b377aff83ae572fa37"
    sha256 cellar: :any,                 sonoma:         "1d5c227e03b62bc5b3511f2407d661df4e59707cd8319cd0e1ee04ae85216eb1"
    sha256 cellar: :any,                 ventura:        "ac808d5d75abcaa86d1bed39738a2ddd2e71ad1988d94b87161f06e7b383079c"
    sha256 cellar: :any,                 monterey:       "430c75305b0861545f895dc15512d68cad1b8cc526e7ec1e891275698c128e4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24daeda46873924ab548a1f1253d9a6d6a91046321f7b93383d1788370bcaa6b"
  end

  head do
    url "https://github.com/fish-shell/fish-shell.git", branch: "master"

    depends_on "rust" => :build
    depends_on "sphinx-doc" => :build
  end

  depends_on "cmake" => :build
  # Apple ncurses (5.4) is 15+ years old and
  # has poor support for modern terminals
  depends_on "ncurses"
  depends_on "pcre2"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}",
                    "-Dextra_functionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_functions.d",
                    "-Dextra_completionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_completions.d",
                    "-Dextra_confdir=#{HOMEBREW_PREFIX}/share/fish/vendor_conf.d"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def post_install
    (pkgshare/"vendor_functions.d").mkpath
    (pkgshare/"vendor_completions.d").mkpath
    (pkgshare/"vendor_conf.d").mkpath
  end

  test do
    system "#{bin}/fish", "-c", "echo"
  end
end