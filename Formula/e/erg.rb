class Erg < Formula
  desc "Statically typed language that can deeply improve the Python ecosystem"
  homepage "https://github.com/erg-lang/erg"
  url "https://ghproxy.com/https://github.com/erg-lang/erg/archive/refs/tags/v0.6.20.tar.gz"
  sha256 "6974e5eef6c2bb6b017d7111819f50f5e13d4eba623caf1310dfc488acd466cb"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "975010c2749c8c217405f383e6da46cfd077a8b2b2a7f89619a0a906e573c055"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6ff8ae9531bee24ba6d6b1e6e40768e4fce30a5c3710bf4a710a4257f266106"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fa0169465db766c0adb8c2001314c0b5bca97705d9d7d2b3f86e02ed40044cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ccc0fc7639e8ab6fdc0062525977551beb290d36657bca373c5ac585ab463ef"
    sha256 cellar: :any_skip_relocation, sonoma:         "160b8dd5d507b2f52fe26a3c37fa66f34016f151b89e104c194b8c266b8309fa"
    sha256 cellar: :any_skip_relocation, ventura:        "06c3fc97c164d6e304bbcea113d44f0c15739a718e710c96579161b9badd6822"
    sha256 cellar: :any_skip_relocation, monterey:       "286529f91b17b15f6099e465b8cbb8820009d1892222ad989b1b11413ebe9fd6"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f9ed9af3b4b98ef65e7f6e729ffa1d425fd3362daafb686f4713137bcc8ca9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad9e1c6a973fac1e772374c95740cfe356d81f2a3213700ec99b65b389c6d55c"
  end

  depends_on "rust" => :build

  uses_from_macos "python" => :build

  def install
    feature_args = "els,full-repl,unicode,backtrace"
    ENV["HOME"] = buildpath # The build will write to HOME/.erg
    system "cargo", "install", "--features", *feature_args, *std_cargo_args(root: libexec)
    pkgshare.install buildpath.glob(".erg/*")
    (bin/"erg").write_env_script(libexec/"bin"/"erg", ERG_PATH: pkgshare)
  end

  test do
    (testpath/"test.er").write <<~EOS
      print! "hello"
    EOS

    output = shell_output("#{bin}/erg lex #{testpath}/test.er")
    assert_equal "[Symbol print!, StrLit \"hello\", Newline \\n, EOF \u0000]\n", output

    output = shell_output("#{bin}/erg check #{testpath}/test.er")
    assert_match "\"hello\" (: {\"hello\"})", output

    assert_match version.to_s, shell_output("#{bin}/erg --version")
  end
end