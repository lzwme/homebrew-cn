class Erg < Formula
  desc "Statically typed language that can deeply improve the Python ecosystem"
  homepage "https:github.comerg-langerg"
  url "https:github.comerg-langergarchiverefstagsv0.6.50.tar.gz"
  sha256 "e48d5cb7370180c6c3cfddbac00099b685e8191e69a6adf5e2424282f3061cd4"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70840dc8578c6200a47ad2e98543be4e2251f5f6c58c811f80b73e8e1d58ded9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "780d1f7a027169b479528b06f52e284bede9b9fcd40fc30ac9405b014cbe1b71"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5086eb762a8b6f297a1d794c82ce34897fbaa68add06c8cd4f15c0d632455657"
    sha256 cellar: :any_skip_relocation, sonoma:        "cabcb362567605681632341dc2eccfcc26c67790564daed6625c178b9479010e"
    sha256 cellar: :any_skip_relocation, ventura:       "64b2022d9f87e133343a12ce0d8d41e6dee873c1c82df5bb10400686bfc8f0e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6a28c3ddaad85361e1e2a0b6c50952912d03b36bd1bf988f9c2734ef4bde4a5"
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