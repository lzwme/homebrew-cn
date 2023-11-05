class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https://github.com/mtshiba/pylyzer"
  url "https://ghproxy.com/https://github.com/mtshiba/pylyzer/archive/refs/tags/v0.0.49.tar.gz"
  sha256 "c07e9adba4a475cfce76fafbf34fdd7153e2ccecdad3bbb01eb99b53d7b66484"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e2aa991d0114c943a634ac82008401ab5fd44ad36275b6057974ed25daeaaf78"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ebf4ca6aa99a24a13b7fb20f8ee6ff053920d030444d07486d36d4283a2718f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f469d43e2e78cd771e84bdb0a6ee61ea60d4d813cf513dc86ed122f6b4a497b"
    sha256 cellar: :any_skip_relocation, sonoma:         "49a45a8508e0ce39e18cf2fcf642f3dd66cb8c5121871cd6afc31a03961ef641"
    sha256 cellar: :any_skip_relocation, ventura:        "003e2e5cbfc379310ce20110a5373ccb886565d6b9723cc68860a09c4aa8f6be"
    sha256 cellar: :any_skip_relocation, monterey:       "41e479a239fff2ea78b8a97cb990a4931e7312ac49de683c1b57dbe342d1ae6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bee7f0d2d3bf81ac5e82bb53afe4ac47d04245b62b92b8be46979ccb110eaee7"
  end

  depends_on "rust" => :build

  def install
    ENV["HOME"] = buildpath # The build will write to HOME/.erg
    system "cargo", "install", *std_cargo_args(root: libexec)
    erg_path = libexec/"erg"
    erg_path.install Dir[buildpath/".erg/*"]
    (bin/"pylyzer").write_env_script(libexec/"bin/pylyzer", ERG_PATH: erg_path)
  end

  test do
    (testpath/"test.py").write <<~EOS
      print("test")
    EOS

    expected = <<~EOS
      \e[94mStart checking\e[m: test.py
      \e[92mAll checks OK\e[m: test.py
    EOS

    assert_equal expected, shell_output("#{bin}/pylyzer #{testpath}/test.py")

    assert_match "pylyzer #{version}", shell_output("#{bin}/pylyzer --version")
  end
end