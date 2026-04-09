class ConfigFileValidator < Formula
  desc "CLI tool to validate different configuration file types"
  homepage "https://boeing.github.io/config-file-validator/"
  url "https://ghfast.top/https://github.com/Boeing/config-file-validator/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "6112eb0508b10886aa922e789abca9996214a1d04da23910680550b13d3b3567"
  license "Apache-2.0"
  head "https://github.com/Boeing/config-file-validator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa851cb84305794f15f2a6e5249aed80b96617e15b4715a47fa371935896e6e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa851cb84305794f15f2a6e5249aed80b96617e15b4715a47fa371935896e6e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa851cb84305794f15f2a6e5249aed80b96617e15b4715a47fa371935896e6e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "20a89e8d3025c2f2a867a9bc7e0b336e66550cc57d8a8e39165eb91b80b03de4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a3f190b8a666088d61b4b6219c9b06fada9948798e0fe018cd374e37ef85399"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "694d98fab11dff221c25e8d5245f778c4797e33f17cb300609d24244208279e2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/Boeing/config-file-validator.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"validator"), "./cmd/validator"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/validator -version")

    test_file = testpath/"test.json"
    test_file.write('{"valid": "json"}')
    assert_match "✓ #{test_file}", shell_output("#{bin}/validator #{test_file}")
  end
end