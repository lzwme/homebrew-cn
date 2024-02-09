class Idris2 < Formula
  desc "Pure functional programming language with dependent types"
  homepage "https:www.idris-lang.org"
  url "https:github.comidris-langIdris2archiverefstagsv0.7.0.tar.gz"
  sha256 "7a8612a1cd9f1f737893247260c6942bf93f193375d4b3df0148f7abf74d6e14"
  license "BSD-3-Clause"
  revision 1
  head "https:github.comidris-langIdris2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1803fe072fc8baeb5ef2446581045958da73200582ef3f8e6dfcadc24463e22d"
    sha256 cellar: :any,                 arm64_ventura:  "06e943073a7f80bd5c1fe1eb2b6f1b1fcdd0a1be6730ad40adb95e2186fb2546"
    sha256 cellar: :any,                 arm64_monterey: "b126157bf30330555525818fa68d97296804f86c4c4a6ba3960168a45d422f7d"
    sha256 cellar: :any,                 sonoma:         "1ba1467dc7a6c42effaec6a515d5d5330d8caf0c69f0878a64e181a42662238c"
    sha256 cellar: :any,                 ventura:        "0fa77260ba214d147af8966e8b15c5e4c1df391d112c1450d17e7d910d0025ba"
    sha256 cellar: :any,                 monterey:       "5aba77f6524c43a82984d9129806fb1d73d7badffe5bc7eb9ee6ab5930bf7fff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e0fe313dab8f7c65f771949e5bbef5222f31aaeed8f340883c58e47bf799af5"
  end

  depends_on "gmp" => :build

  on_high_sierra :or_older do
    depends_on "zsh" => :build
  end

  # Use Racket fork of Chez Scheme for Apple Silicon support while main formula lacks support.
  # https:github.comidris-langIdris2blobmainINSTALL.md#installing-chez-scheme-on-apple-silicon
  on_arm do
    depends_on "lz4"

    resource "chezscheme" do
      url "https:github.comracketChezScheme.git",
          tag:      "racket-v8.9",
          revision: "baa880391bdb6b1e24cd9bb2020c6865a0fa065a"
    end
  end

  on_intel do
    depends_on "chezscheme"
  end

  def install
    scheme = if Hardware::CPU.arm?
      resource("chezscheme").stage do
        rm_r %w[lz4 zlib]
        args = %w[LZ4=-llz4 ZLIB=-lz]

        system ".configure", "--pb", *args
        system "make", "auto.bootquick"
        system ".configure", "--disable-x11",
                              "--installprefix=#{libexec}chezscheme",
                              "--installschemename=chez",
                              "--threads",
                              *args
        system "make"
        system "make", "install"
      end
      libexec"chezschemebinchez"
    else
      Formula["chezscheme"].opt_bin"chez"
    end

    ENV.deparallelize
    ENV["CHEZ"] = scheme
    system "make", "bootstrap", "SCHEME=#{scheme}", "PREFIX=#{libexec}"
    system "make", "install", "PREFIX=#{libexec}"
    if Hardware::CPU.arm?
      (bin"idris2").write_env_script libexec"binidris2", CHEZ: "${CHEZ:-#{scheme}}"
    else
      bin.install_symlink libexec"binidris2"
    end
    lib.install_symlink Dir[libexec"lib"shared_library("*")]
    generate_completions_from_executable(libexec"binidris2", "--bash-completion-script", "idris2",
                                         shells: [:bash], shell_parameter_format: :none)
  end

  test do
    (testpath"hello.idr").write <<~EOS
      module Main
      main : IO ()
      main =
        let myBigNumber = (the Integer 18446744073709551615 + 1) in
        putStrLn $ "Hello, Homebrew! This is a big number: " ++ ( show $ myBigNumber )
    EOS

    system bin"idris2", "hello.idr", "-o", "hello"
    assert_equal "Hello, Homebrew! This is a big number: 18446744073709551616",
                 shell_output(".buildexechello").chomp
  end
end