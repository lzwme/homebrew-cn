class Erg < Formula
  desc "Statically typed language that can deeply improve the Python ecosystem"
  homepage "https://github.com/erg-lang/erg"
  url "https://ghproxy.com/https://github.com/erg-lang/erg/archive/refs/tags/v0.6.24.tar.gz"
  sha256 "ab445ab68f2c38d963c6a71c2d0be0e64cb313b1ff92b7e54fd99d3038d9dc09"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd7ae5dddbe33c6ca0ec990c2260a67320d2271ee54f13108db6cde6738e5139"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6dfc55684a004f60092b78f2f777093dda7b3d8d5c881784a780bc1342edcd8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32065a0e8f298c223c0908c98e533964142c94afe468af28e84eb110d077e673"
    sha256 cellar: :any_skip_relocation, sonoma:         "cdf3574680df36ac77a634bc707d49f8c0ba8cf7108dbe01ee4e3146dcda76da"
    sha256 cellar: :any_skip_relocation, ventura:        "93099710b18acee1fc688c4ce48aec014240795f18fc69e5bbb185ac4c98e9b0"
    sha256 cellar: :any_skip_relocation, monterey:       "fc357e005d489db6956af0c1b1e14b202b08087b4462a84f95d5665ee8045f18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15f75fc77c5464e957fc94789a333c9b67bcd360d76942083223355e8d7c6044"
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