class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https://github.com/mtshiba/pylyzer"
  url "https://ghproxy.com/https://github.com/mtshiba/pylyzer/archive/refs/tags/v0.0.37.tar.gz"
  sha256 "e085e07e41115ab2eaa894c04ed6cbacfc9665dbcd9c61426fd8147e802a0f90"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35806ecd60d1ab8685c53d2153f000c230f55e3378640be85ce089b772959ec0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e787523923d48441674723ce2450480987856b3940b674698a40dee4784a80c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8437e825d3f937e3db7dd189c3e83128c5aa702cfbc39768ec486cb59cc7201f"
    sha256 cellar: :any_skip_relocation, ventura:        "64b7ca251ed6ff74986074be93e1cbceb24e3db01b1549d0b2bb306e813a5f0d"
    sha256 cellar: :any_skip_relocation, monterey:       "550fb230322ea8ef4d462129af66ce9a883fe52587e464f74568fa85da853611"
    sha256 cellar: :any_skip_relocation, big_sur:        "d613c860f9b28ff28af1424d488dd474a0652ea2e9ee350cd95ddce6f3bb896c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36f3f683208ca95b114f87e83edfd1f515bf27243e784dbd3ee505451c3f3e6b"
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