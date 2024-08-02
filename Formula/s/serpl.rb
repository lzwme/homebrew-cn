class Serpl < Formula
  desc "Simple terminal UI for search and replace"
  homepage "https:github.comyassinebridiserpl"
  url "https:github.comyassinebridiserplarchiverefstags0.3.1.tar.gz"
  sha256 "fa0d5b9de9a8820ba46d8d2a7e4a20fc99bcc433816e9368fe547bf7b6c1d1b2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9de2449148c1065fe491d3661f862e25d4226510a0c979643a3e5c90431e2a6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e643a027a3939666decbbdf129aba420116b09fe89c637a9826b2a37b999ea5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab18d7df1542c7bc9eae8e76d85a107407abd75eb8b0632390b273d8b215089c"
    sha256 cellar: :any_skip_relocation, sonoma:         "5860764a15cfdf22ab6d1d03d254601c82eeeb2c12842cf09283f06af31ca2b8"
    sha256 cellar: :any_skip_relocation, ventura:        "684a5d43aa8e8963b30fdb32ec9e8f7d1c6f557a82a202106e151ec4eb8bb5ef"
    sha256 cellar: :any_skip_relocation, monterey:       "d045f9ef992ac3166dbbe5fb5eee1d5ac9fd62d8c289ffa8838ec448c73859ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e94ad8f8a160e4afc2537251bd0b77447ea85669aeec8536e33e40684088fc2"
  end

  depends_on "rust" => :build
  depends_on "ripgrep"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output(bin"serpl --version")

    assert_match "a value is required for '--project-root <PATH>' but none was supplied",
      shell_output("#{bin}serpl --project-root 2>&1", 2)
  end
end