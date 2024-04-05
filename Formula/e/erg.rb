class Erg < Formula
  desc "Statically typed language that can deeply improve the Python ecosystem"
  homepage "https:github.comerg-langerg"
  url "https:github.comerg-langergarchiverefstagsv0.6.34.tar.gz"
  sha256 "2536aff4faaf5e8110e2c9830ab029a8d34c449beb5d251c64042076ba6df759"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c12f80c891b4b697407437ff147ba2f04900acf787feb1f786ba88292ba90a06"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1114dc19dad9fed53268adb3f9dce333d8414e05e2c4fedba6d3ad1f38cac6d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70804146d0e2752a56fa34b4c81ba2b4af42d355f66d011b303a1d55b6985c89"
    sha256 cellar: :any_skip_relocation, sonoma:         "af61ab1505d37f202f4df5a3b2a5a18040b9ac8c4e6a28fa7e54fb268685c18e"
    sha256 cellar: :any_skip_relocation, ventura:        "656a16966ac4f56ed19e5dc524640de0c5eb9b637bfd51a0f5a9f1c0e41c70bd"
    sha256 cellar: :any_skip_relocation, monterey:       "a3514ee92681bcdfe56718b49e64743477026d0f2068d1f706f722a883d22a6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fa3812f4ef9dec978beac001dfc7f5e32d45df26325fd84ea24c92971afcab7"
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