class Erg < Formula
  desc "Statically typed language that can deeply improve the Python ecosystem"
  homepage "https:github.comerg-langerg"
  url "https:github.comerg-langergarchiverefstagsv0.6.37.tar.gz"
  sha256 "8c5afca7a93c0834344f8d472b48f0076c0185e33621302b2999bed6703f188e"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c9ae5475fe05815de1652aa15539866e1a639c2a8fb475c07597b6f6cb871f2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "638b2bb9b4109c7ec52aa0fefe18f10264238dae6ce02a6541a2d1bac8e4de68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abd0ca406d947c16dd7ac10ed53844e9e7cf98f4ee634a8cda20cd9c76c872cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf36f9b916127ce19619da42b7be5d9a077c827703ddb658b7a35e2b4f7c97ce"
    sha256 cellar: :any_skip_relocation, ventura:        "fa4087c1b06ccca4b94f85788181a53421aa1fa4ee904c58447c9dc4745bed02"
    sha256 cellar: :any_skip_relocation, monterey:       "6d20ad60089a564c29e36fcb3b6f2607c7e5f96cd323dfbd805a130a3e0a8bbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3c0ddb2d2caff9b8ad692dda2a916d231e20df199e6af276d1bc85212148b90"
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