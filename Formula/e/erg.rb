class Erg < Formula
  desc "Statically typed language that can deeply improve the Python ecosystem"
  homepage "https:github.comerg-langerg"
  url "https:github.comerg-langergarchiverefstagsv0.6.42.tar.gz"
  sha256 "ad9a89cffcca8dd2d51eb1197bdc3b986f8fb2b47af67c2a14de93b5450f27d2"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ecdb9fb2c7960f6d18e900e1bae8ff9b701cdbde9b48600287f5147ccef8b312"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c318857f06e20e0faa34b55d3f4f5e6915437e0322e8a9b4a830044f077269b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f56492e9ae21adf01db73a1eb1c5fc1cc7a8d8e5f614d413fe24904c733752f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "c462151c93bef60d4da9a211104d9ffc2b28a8688798dc2cc74e026b9c089116"
    sha256 cellar: :any_skip_relocation, ventura:        "afdbb2f50b5d87c3cc390611a65f4bd1c3d006deafcfbc7c80fbe95dd78612f2"
    sha256 cellar: :any_skip_relocation, monterey:       "9244c4df923989216e9f21d111dc1f9ec75ce39f9efd83d52ecf0150bacf48e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3f15fa9007d3fe95e2595ae56f6a7d3da256e2b184d4419f78894a70f9f7dcd"
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