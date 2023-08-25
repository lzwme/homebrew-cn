class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https://github.com/mtshiba/pylyzer"
  url "https://ghproxy.com/https://github.com/mtshiba/pylyzer/archive/refs/tags/v0.0.41.tar.gz"
  sha256 "0af70ae8d9fb13c4db85e428dbd881224d01768a010b94bb15a6cd82cddf77b0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0dd86c8abe6653f3a645a921894e372d18e84974d3d21dd052f901c01635701"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "771a25a034d164173f8fd2e038dab0796d5774b2cdc4b24dcbd4753d3f96f853"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7ca13b938af764a7072e004ee28572026e9afdeff6ac8a6ac1ae28da1e60022"
    sha256 cellar: :any_skip_relocation, ventura:        "1af09bfd4d14349f4139aa279f795e31ee91f14c374dc020bc1d21298fd37099"
    sha256 cellar: :any_skip_relocation, monterey:       "c136980ef943cebe799f8851dad7d95a23afa0b95601cc363f2416ca9b6a2f78"
    sha256 cellar: :any_skip_relocation, big_sur:        "292d5f516c1ac51216903acc45c104eff76ee09c25bfeb0144bfe4ce0ed082e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "497982ab4a315f0d6a806f711c2a8df26528e10b2e08ea5377080339dea7db75"
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