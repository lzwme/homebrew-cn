class Erg < Formula
  desc "Statically typed language that can deeply improve the Python ecosystem"
  homepage "https:github.comerg-langerg"
  url "https:github.comerg-langergarchiverefstagsv0.6.27.tar.gz"
  sha256 "43dcab115104ebf6ff1bc7a85db5221158bf9136102b97253ec9ea4b97d97a18"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a21b5b70e1352186511163a69501914299f9efe8695444f15f637bda86d79b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "acdf5a9c004420b616080fec47f33ff3ee5e4239fbdb9ecd1b7145ec3552acf5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e2b6c353302ab23ec2eacf7aa7ccb53d3d6aaf862a3b5cf9eb0f3273aefa408"
    sha256 cellar: :any_skip_relocation, sonoma:         "d1120a9b4fa26ea11765363c70e343522197ea105138650401bd7777f8ab870e"
    sha256 cellar: :any_skip_relocation, ventura:        "51dab177a231cbcf80fe4bf2ef034464c9f23472eb8997c67a76f7c104800e80"
    sha256 cellar: :any_skip_relocation, monterey:       "ae9a7ec8fdd3141b252886eedadc34c0d740851a579640dea48a503e8006cc8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "757146a9bbf4beb31c6d4f7e8404f74cf4e4487beadbede7f385061729c61efa"
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