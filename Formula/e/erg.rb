class Erg < Formula
  desc "Statically typed language that can deeply improve the Python ecosystem"
  homepage "https:github.comerg-langerg"
  url "https:github.comerg-langergarchiverefstagsv0.6.39.tar.gz"
  sha256 "bf842a6264940ae3cd2384d80cce7a7aff0633e330542000ee2aa43b2fbeaad4"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "caef584a8e2a65119cd22d08399d279d7e5c474a825f79364b8d35fe70cb6774"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6a3f46d79f84d348b114cd4478863b00479d94d420626d575d5ec9db66de2da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "448efc3112b94d9081620258179a956859d6a20496538b7e4c89acbc04b12e16"
    sha256 cellar: :any_skip_relocation, sonoma:         "8a8073d4f70ea49cbe33c27d1d0ed595d8fa3c93abd9395fa520e8df244e91ce"
    sha256 cellar: :any_skip_relocation, ventura:        "6b0eda58deaaa92bf3c366644bf304e154ca2ba8baf00ddd4b96db872f8e11ca"
    sha256 cellar: :any_skip_relocation, monterey:       "8f3d0d2b327e006202ed5cd35327756c7fd4aec8d91f883e2097243b2d5d53d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edc209813b62592e07305f3046d594c2dca9828e45d7e0068e5affcc901a91de"
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