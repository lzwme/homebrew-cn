class Erg < Formula
  desc "Statically typed language that can deeply improve the Python ecosystem"
  homepage "https:github.comerg-langerg"
  url "https:github.comerg-langergarchiverefstagsv0.6.40.tar.gz"
  sha256 "3084b5642a0edccd3c343d42db3f6efb0d8d13be4932f5e4949702fcd16ba0f3"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "108809e12c59203fbea0663447829a08e2d094afada7c2bcca90658c5e37f901"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "781b4878ea960db4d1785e2c5fbb2d1b46eb50ce9c8edad4006e3f507c360102"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b9701706d28e364dc641b719e25c8dec5125af1efb4a46e1a4a0aa0fd466d78"
    sha256 cellar: :any_skip_relocation, sonoma:         "376cf8abeef182cfa23bd46d46a674d2f39cf1a81430f3eec0a65b0c5bc0586a"
    sha256 cellar: :any_skip_relocation, ventura:        "e174997ea99089f5b85b03d8c34013b9d1d4a133940dfd67ec6da86845d2ff17"
    sha256 cellar: :any_skip_relocation, monterey:       "d1cac7d976bb1ad30bd8edd522049a3bdb7fb2ba1eb91dc97d5869240189d952"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "945870757c6cb767f75b9dde67a117a3588819e5020cc7749090ba5d7f66cff6"
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