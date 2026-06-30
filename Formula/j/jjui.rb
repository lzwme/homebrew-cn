class Jjui < Formula
  desc "TUI for interacting with the Jujutsu version control system"
  homepage "https://idursun.github.io/jjui/"
  url "https://ghfast.top/https://github.com/idursun/jjui/archive/refs/tags/v0.10.7.tar.gz"
  sha256 "87fd894a2272d91ad7a4576f0d44cfd161421c3a242e1e91f84c40b6357e27bb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4efd9e52fa5aba04d2aeeda558f2bfde94989332502942728ab72549897f902"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4efd9e52fa5aba04d2aeeda558f2bfde94989332502942728ab72549897f902"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4efd9e52fa5aba04d2aeeda558f2bfde94989332502942728ab72549897f902"
    sha256 cellar: :any_skip_relocation, sonoma:        "b651636a90c3e13cda6fe651679b7378bef496e832bd39d5ddcdbb9a49c6fd6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bbf68162face13a5f569dcb7ea6f3c7f529aded7153a9998f2514b71b0620b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e6b2b788b2abd9e68d62d46936a330f4a21789bb2c413bc55838fdbfbaecdc9"
  end

  depends_on "go" => :build
  depends_on "jj"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/jjui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jjui -version")
    assert_match "There is no jj repo in", shell_output("#{bin}/jjui 2>&1", 1)
  end
end