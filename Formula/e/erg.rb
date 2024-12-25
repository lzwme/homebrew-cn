class Erg < Formula
  desc "Statically typed language that can deeply improve the Python ecosystem"
  homepage "https:github.comerg-langerg"
  url "https:github.comerg-langergarchiverefstagsv0.6.49.tar.gz"
  sha256 "696a4bf0f5368858243e4bafea36fcfcb7d041fcbb711bc2c4e4b8c7611cb944"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06dfafdc45f06761e40a7424ef6512f7b119cccbe2552fc92a3209ccc03da58b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77b98d80a3fd3b36d6e136ad7f6a0a9dc3743476a5f1ebe457dbb0855e4bce2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68108a51fdf35b179d3d313989bb52f180dd10e6fbe75a2b54d25e9ba0148b56"
    sha256 cellar: :any_skip_relocation, sonoma:        "028a95a02d539d4787ea14bb356b5a23688db0b5544925fa647c1d16b6c12be9"
    sha256 cellar: :any_skip_relocation, ventura:       "6d6b93f2dcf05838fe15aac1c86a6f411cb6463eb1609d49f8a85015100b6378"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21d472d12b3505470635cacaca4d40beb1a9b32b3f74dcc2fb0615fcab88da0d"
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