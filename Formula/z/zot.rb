class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.31.tar.gz"
  sha256 "c0b4c2daefb3a31d1800a5d0ec30e50c6dc213cd5a3244d758da7722a4e704f9"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2750a470f98ad1803dfa131c02a5183b1fd709b26199f352cf84c7a7545a7ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2750a470f98ad1803dfa131c02a5183b1fd709b26199f352cf84c7a7545a7ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2750a470f98ad1803dfa131c02a5183b1fd709b26199f352cf84c7a7545a7ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc54e5b8f2581b4150d33a73827a3fdafa684299524ae2124aa7c9dc932de45c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6d8819d381f6f801456dcdb2cc167a39612ad92228f1d350868c437d645339e"
    sha256 cellar: :any,                 x86_64_linux:  "cd46506da75acea6613ec65c6f9624905b5ad8797617b20172bed32b73d970f9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end