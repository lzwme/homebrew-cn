class Idris2 < Formula
  desc "Pure functional programming language with dependent types"
  homepage "https://www.idris-lang.org/"
  url "https://ghfast.top/https://github.com/idris-lang/Idris2/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "7a8612a1cd9f1f737893247260c6942bf93f193375d4b3df0148f7abf74d6e14"
  license "BSD-3-Clause"
  revision 5
  head "https://github.com/idris-lang/Idris2.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "048b3581cbaec1cc94fc16a9ccb1ba2da5f504f64022100bd372df91afe7ece6"
    sha256 cellar: :any, arm64_sequoia: "f9041be4570a258556c3871fb7cc4a4bfe63524b472f543f603871fd01e706b2"
    sha256 cellar: :any, arm64_sonoma:  "f4b65da7c0383f507bd5860fb2f51592e1219f9f6642ca46373948839f9799d7"
    sha256 cellar: :any, sonoma:        "8138582f9113a8403a35d94380ea46c9cbf10364d17a6669fdb8e01db67b0cb2"
    sha256               arm64_linux:   "d2768e9b6d672a1264c628546a56285e4bf18a64a75c9da8cdd6bf09a8328ca5"
    sha256               x86_64_linux:  "93ea07956b6e25e5d28deb37b0fbed777fb77fcb41dcbcdda0e24bed56b2c868"
  end

  depends_on "gmp" => :build
  depends_on "chezscheme"

  def install
    scheme = Formula["chezscheme"].opt_bin/"chez"

    ENV.deparallelize
    ENV["CHEZ"] = scheme
    system "make", "bootstrap", "SCHEME=#{scheme}", "PREFIX=#{libexec}"
    system "make", "install", "PREFIX=#{libexec}"
    system "make", "install-with-src-libs", "PREFIX=#{libexec}"
    ENV.prepend_path "PATH", "#{libexec}/bin"
    system "make", "install-with-src-api", "PREFIX=#{libexec}"
    bin.install_symlink libexec/"bin/idris2"
    lib.install_symlink Dir[libexec/"lib"/shared_library("*")]
    generate_completions_from_executable(libexec/"bin/idris2", "--bash-completion-script", "idris2",
                                         shells: [:bash], shell_parameter_format: :none)
  end

  test do
    (testpath/"hello.idr").write <<~EOS
      module Main
      main : IO ()
      main =
        let myBigNumber = (the Integer 18446744073709551615 + 1) in
        putStrLn $ "Hello, Homebrew! This is a big number: " ++ ( show $ myBigNumber )
    EOS

    system bin/"idris2", "hello.idr", "-o", "hello"
    assert_equal "Hello, Homebrew! This is a big number: 18446744073709551616",
                 shell_output("./build/exec/hello").chomp
  end
end