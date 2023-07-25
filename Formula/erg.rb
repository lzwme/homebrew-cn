class Erg < Formula
  desc "Statically typed language that can deeply improve the Python ecosystem"
  homepage "https://github.com/erg-lang/erg"
  url "https://ghproxy.com/https://github.com/erg-lang/erg/archive/refs/tags/v0.6.17.tar.gz"
  sha256 "70b4495ac0d158900ed8f0267ebfce7d4eeb82b9d1a8e3ae316bba9203341309"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13629906aa18adbfa474872712d7392d9980ebebc019c9a398972111a72745a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d100f2c60fdc5af6c0e9c898ef3052fd0cb1baccd2164eca42c79cdad1f467c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76ddadc802a3388e9f5fd61a30ae377f9ac58a8113aa9a854436d5d9c9e7fe72"
    sha256 cellar: :any_skip_relocation, ventura:        "202739cf124f09a60f84c50fd67f0ec391381e3bc86f0ea19b95f67aa2ce9a82"
    sha256 cellar: :any_skip_relocation, monterey:       "96e31c2e7253a31b5b5a144d64244a8a7476df58cd9fd946a547824ad28f2531"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6b3c4e088213594f46bcf5e2b12462e924946882fb6605999fe948492c061f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20afd87bc4809dc00bd0ca73c48afe58323a1d24068f91dce45a8578e26e66bc"
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