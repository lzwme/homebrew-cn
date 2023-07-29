class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https://github.com/mtshiba/pylyzer"
  url "https://ghproxy.com/https://github.com/mtshiba/pylyzer/archive/refs/tags/v0.0.39.tar.gz"
  sha256 "7ecd4d0da55c75ba5366285c15281571eade3b7b58a1cb0dd0f51c6d6a438aad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ffb5f8d850b1086f0c1ade2100f1438a9e1faacaad2fa91698d925e882a7f524"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffb3a97741cbbf910a3188b6c306bc403a9faccc16fa6d67e37a680d8ea26cae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33e0acfaeb0aa31f8238b9a33ce23ef23c388496ee1ce0c6fcac7d2952e629b0"
    sha256 cellar: :any_skip_relocation, ventura:        "5be955e926aa861331537ebc4e5f89676d4d55d3538199159d6bfa479f415e79"
    sha256 cellar: :any_skip_relocation, monterey:       "4f1e0030c698c69e62e7a3b458d1361b45f22941a8d0ed86f9c89027929b3cf5"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4fd02bdbd973e6f1678b9252708c6a48b076364dd89c6b2bb463285393a1603"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "174875e23f6631f988a68eb3abad3d3f18aff528c9db4d89d3587e0dc87bbec4"
  end

  depends_on "rust" => :build
  depends_on "python@3.11"

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