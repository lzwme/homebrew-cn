class Erg < Formula
  desc "Statically typed language that can deeply improve the Python ecosystem"
  homepage "https:github.comerg-langerg"
  url "https:github.comerg-langergarchiverefstagsv0.6.29.tar.gz"
  sha256 "3e974c332a089ab6202d04c4d9de1f3f796baf344c3cd5cf19410241a70d3e6d"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "20719f4808076d23b853a8706347e7dca42fb38ca9cdcc0df6d8a0123357bb55"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40e9cf176cf7f97beb30c3ab13096c2c635fbecb362c1620e3c86a68405f413c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9947a2e1432d7c36d57b2facc61d855eba4c15531a631d16ac256c088266030f"
    sha256 cellar: :any_skip_relocation, sonoma:         "a92df101e76d270c5dc61014066628825fc2ee67fbb1ffcd53b532a5dbbd648d"
    sha256 cellar: :any_skip_relocation, ventura:        "33b4b2b2927ca8216fe965ece69d6cc43432b1fe73f50c47702b59be552329c1"
    sha256 cellar: :any_skip_relocation, monterey:       "79609c84d6613aa69e959e93ccf6a588e81851dc16e57da6e93c3f4699143505"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a7577e27ff9fd319d74ccc3618c2e656186fd68a46fd6cf44f1aac4e6a26256"
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