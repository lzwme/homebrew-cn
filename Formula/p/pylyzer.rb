class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https://github.com/mtshiba/pylyzer"
  url "https://ghproxy.com/https://github.com/mtshiba/pylyzer/archive/refs/tags/v0.0.45.tar.gz"
  sha256 "c3980ebb0c0ce825f0e50a3ae9f5e8d1af4b5b712bc99c4cff2205b594cba99a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79538cf433dee8395098ba38e28da5a895771b23aca208a28bbbe82afb03b740"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5120caf357c2cea2e5f927f0f0462d42873885a7d3dbd555dcd89627b99fac7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d2bfe86a2f42d16027f20f8d9d17426e4073812f91bf75b5805276c974d9eda"
    sha256 cellar: :any_skip_relocation, ventura:        "4eda5736fb2a8092b4eaacb764e3b115516789169a6878c5d0d1e4bc447dd9a9"
    sha256 cellar: :any_skip_relocation, monterey:       "44beb9590532a7f51eb6b969fb844cdaaed009bbf8de3d4c2061abf97c525e05"
    sha256 cellar: :any_skip_relocation, big_sur:        "82a7f5b008625a0552a5d8ea7b5906813970f905a2dd951b040740fc9c151b24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b7bdebc1a21e3db4eb86b0cd52ae812a35f7f61a87c219bad015716e3479e70"
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