class Riff < Formula
  desc "Diff filter highlighting which line parts have changed"
  homepage "https:github.comwallesriff"
  url "https:github.comwallesriffarchiverefstags3.3.6.tar.gz"
  sha256 "9f847d7490655625eac44f4b0367708904bef6a98e2f3e890b1be1d3b3cecd32"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fa96e7220c7b6420e6e8f78c99381c636cc32e7fdeb1d52082153f60ad02384"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a279974a1a138e51b38970f54bdf951454efc2e40d876f006d6f87e399e723b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0343f493312a443bd8debb4b0c2e4131e9d7aad9430667d3b4c8f8d76197f0b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "508d23bab36ff676766f3aa90b4fc82802ffd3560f295c46955cf29d0a98030e"
    sha256 cellar: :any_skip_relocation, ventura:       "3925d6e57cc057e15f2abea829aeaca8c291fe92d67dfe6186c94731e696851c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59e4adb90b027bdcb00129f8c749b06a6327e12750c752676969c58480004d9d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_empty shell_output("#{bin}riff etcpasswd etcpasswd")
    assert_match version.to_s, shell_output("#{bin}riff --version")
  end
end