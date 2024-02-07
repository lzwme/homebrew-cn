class Erg < Formula
  desc "Statically typed language that can deeply improve the Python ecosystem"
  homepage "https:github.comerg-langerg"
  url "https:github.comerg-langergarchiverefstagsv0.6.30.tar.gz"
  sha256 "13e103513eb15612855af89964bf6950e5644b0d9d576ea42cd9f2f64bb93e16"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "54ad338b40f1a74943f4e9428511563a9569917d2399e7f35b1b50530e43fb55"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3dcf52e9dd65019d0ee233c5640d86d0578e9db34d512e6d85aa81dace0bea3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4e182ab4cc0b4717212a18ccbe9b95d5ea2cba181e212a465931540c4aaa526"
    sha256 cellar: :any_skip_relocation, sonoma:         "16f786cbc8c1cdfb89c0df6b2b5afc351692e4cc69927f72a8af64b9fdedff7a"
    sha256 cellar: :any_skip_relocation, ventura:        "2c7596246154835e9da7b14f9dc27ecab786ea60fb94dcd4b5db425ce370306c"
    sha256 cellar: :any_skip_relocation, monterey:       "3fd763180cc4341097f446bf899909807450c0afd9f39e709584924dd809e15d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6427e907f57bcccf1f3830aabaca2e36c3cc48359c2ee6a712baf1bbeb4dbbed"
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