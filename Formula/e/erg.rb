class Erg < Formula
  desc "Statically typed language that can deeply improve the Python ecosystem"
  homepage "https:github.comerg-langerg"
  url "https:github.comerg-langergarchiverefstagsv0.6.44.tar.gz"
  sha256 "f70e8c01d859f3e6e9e3bd99350d3bdc0794c04914568529f6651273db0eb682"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36a668b9eeabda7d6920e52c1f8c079ba59744b9bde1b97092e9cfe4b858e7e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61478f98440af356de56ae93c5f23ac5646090911c19d200cd88cecc1de29edb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2603fc3f3aac226c9ffd1e2a3695430ce72f63ad93b35dd1a52ffc0cdbccb190"
    sha256 cellar: :any_skip_relocation, sonoma:        "008eeecd5585916ddd4776ff36eda65de4a3aa3bc982c0e20de40f1f8df1e52a"
    sha256 cellar: :any_skip_relocation, ventura:       "4cc3a56c4b47c17e3d3d1ec70c74063d0fcb4fc07a2c2c0bd164e29e39cb692c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98dbf346c405b536a28477f6b87a77357def50a31764418b41dc10f15d3570b0"
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