class Erg < Formula
  desc "Statically typed language that can deeply improve the Python ecosystem"
  homepage "https://github.com/erg-lang/erg"
  url "https://ghproxy.com/https://github.com/erg-lang/erg/archive/refs/tags/v0.6.25.tar.gz"
  sha256 "6f85ffb21082c83393832ea570147b3e49b6e79e17e853bb889b9612ddeea7ed"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e12f4cea192ae8fde32623d7eab33387b16da8260c2c6d99ffad4d4890d835fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "056dcb5c98538690e3394565e840020b63c9d7b85b412adc8a305ab9e1685797"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7837adff009cf1c988187cadc9baa3725c1783f693af716f5aa23fbc76a67ad6"
    sha256 cellar: :any_skip_relocation, sonoma:         "50bfb4db23bfce6bb3b4ce99b92212a19a7ecfcbf1b8d45055a03d780c1695da"
    sha256 cellar: :any_skip_relocation, ventura:        "31475af7a0492623b3fca6208cc2aa3fe49518559d9647f0a3da474cfc081adc"
    sha256 cellar: :any_skip_relocation, monterey:       "d63ef63eda9e7e0adc2932149b781f2c0b0d66e877bdbcd47bcb4188911efede"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f992a2f54d3673997944c46e56ba98e5127b99797fcc800ebb034decb8910c1"
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