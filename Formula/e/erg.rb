class Erg < Formula
  desc "Statically typed language that can deeply improve the Python ecosystem"
  homepage "https:github.comerg-langerg"
  url "https:github.comerg-langergarchiverefstagsv0.6.43.tar.gz"
  sha256 "c3465f5599630ca37d2b940a297ef65420529bd4b30fb2e00aab702c92bc1e57"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b2b2849f6edc5811f8ad1f180c496550c164a8797f96c398ec28b6523d5e3581"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca3fc4979fd2bd95d3838dff4c7432dd8f99a17894361d700f06e4f981f77464"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56300f3e740647a4db01f221a63a28275500dff6aa54fa83253bcb2966bf63a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "ea44e32f8900985a0cfbb44ec05e541f7716ad12f801b1b91d32aa6fef0bc911"
    sha256 cellar: :any_skip_relocation, ventura:        "702602a79b61dc44165d106eb43fa78dbccdf8f3b0b6d3ffaeafdac83d950a40"
    sha256 cellar: :any_skip_relocation, monterey:       "3e569bb04e856c11c164ecfeeb6236e98ebf95517ebcb1029e20a7a780b55da9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c339713be24f1dd141a3682228f4148d03f588b4fb194f5ddc11ba4e14e55d69"
  end

  depends_on "rust" => :build

  uses_from_macos "python" => :build

  def install
    feature_args = "els,full-repl,unicode,backtrace"
    ENV["HOME"] = buildpath # The build will write to HOME.erg
    system "cargo", "install", "--features", *feature_args, *std_cargo_args(root: libexec)
    pkgshare.install buildpath.glob(".erg*")
    (bin"erg").write_env_script(libexec"bin""erg", ERG_PATH: pkgshare)
  end

  test do
    (testpath"test.er").write <<~EOS
      print! "hello"
    EOS

    output = shell_output("#{bin}erg lex #{testpath}test.er")
    assert_equal "[Symbol print!, StrLit \"hello\", Newline \\n, EOF \u0000]\n", output

    output = shell_output("#{bin}erg check #{testpath}test.er")
    assert_match "\"hello\" (: {\"hello\"})", output

    assert_match version.to_s, shell_output("#{bin}erg --version")
  end
end