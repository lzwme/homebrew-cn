class Erg < Formula
  desc "Statically typed language that can deeply improve the Python ecosystem"
  homepage "https:github.comerg-langerg"
  url "https:github.comerg-langergarchiverefstagsv0.6.47.tar.gz"
  sha256 "ee47187e7de9f12c3b4630cd81ca0e4eabfcb7ffc48bd957d4e0ba8ef14c8839"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c0e8f3bdef3f61f12adc1a7946216f7b2837f41be14988ff9846ee7ac8453e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32fd9c25f7d362e979ba88ad5c54d1a9808440c5264b4ab63de1a8d080e0de3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "17cb3da8bfb70288756c878a4fa564951d23bfa9b3aeba28d7201cac07c80d9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f26264f7f4864d361e53a66d0a12058a72254890f52371ec2c30b530ddc2261"
    sha256 cellar: :any_skip_relocation, ventura:       "05473caee638cecf2d6cc97051529d8f2137826c56e6c90727493e15285ddbab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd9a444f19d43e4acbf95c0ad10e9330cdf52d92fffdaf88ceacaac69c2504c3"
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