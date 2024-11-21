class Erg < Formula
  desc "Statically typed language that can deeply improve the Python ecosystem"
  homepage "https:github.comerg-langerg"
  url "https:github.comerg-langergarchiverefstagsv0.6.48.tar.gz"
  sha256 "80e77c163f1dfc7d6545c661f5fbda10a8521dc7fe510edb624730b66c44b8c0"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9388e4b2055f436d94f9b149b5d2d35c8eabefcdec7f723ef3fc0707e56311b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db47effb50a16f1ded97d28301a8965db178fc612e3c08fd218622a2c0d9efbf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "004781bfbb53f29bb18dc4258a02141e5ba9c9eb5f428f15b146136f69a2b6b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "667063ee3486f2096d20c4d1a06b1a3fc4a5cb6c3a6b38d442900c142aeaac00"
    sha256 cellar: :any_skip_relocation, ventura:       "fe3bb9844ffbbf0e806cca3e4fcf1043d6157e3beaeb9d728d3fd202642e1e63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3910b7c90a75e1478a3eefae11d317a97cab0c69b13eb15f6622db6d68f5d8d2"
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