class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://ghfast.top/https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.12.9.tar.gz"
  sha256 "196bed4a8008ad6f085ed0bb053a2505df15d9d00daa5175e4ef60a78df34628"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "baf3571056da18efa5d5bb7165e4258a088219a0f621a52a4e47b894310d4123"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "baf3571056da18efa5d5bb7165e4258a088219a0f621a52a4e47b894310d4123"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "baf3571056da18efa5d5bb7165e4258a088219a0f621a52a4e47b894310d4123"
    sha256 cellar: :any_skip_relocation, sonoma:        "83fb35e0aae4a07c3354f55ee3678c3353612b8e1596a7a68b844a1df5b5545a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c11b641ad58fd20c44fe2de74b1d29a4384d79e9bcc54ade6fcff46c3eac7eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52790b938905de3ccd0141f3d9a235d3b0ff2e0ec90f96994c8c93f2f1665f8b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/oasdiff/oasdiff/build.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"oasdiff", shell_parameter_format: :cobra)
  end

  test do
    resource "homebrew-openapi-test1.yaml" do
      url "https://ghfast.top/https://raw.githubusercontent.com/oasdiff/oasdiff/8fdb99634d0f7f827810ee1ba7b23aa4ada8b124/data/openapi-test1.yaml"
      sha256 "f98cd3dc42c7d7a61c1056fa5a1bd3419b776758546cf932b03324c6c1878818"
    end

    resource "homebrew-openapi-test5.yaml" do
      url "https://ghfast.top/https://raw.githubusercontent.com/oasdiff/oasdiff/8fdb99634d0f7f827810ee1ba7b23aa4ada8b124/data/openapi-test5.yaml"
      sha256 "07e872b876df5afdc1933c2eca9ee18262aeab941dc5222c0ae58363d9eec567"
    end

    testpath.install resource("homebrew-openapi-test1.yaml")
    testpath.install resource("homebrew-openapi-test5.yaml")

    expected = "11 changes: 3 error, 2 warning, 6 info"
    assert_match expected, shell_output("#{bin}/oasdiff changelog openapi-test1.yaml openapi-test5.yaml")

    assert_match version.to_s, shell_output("#{bin}/oasdiff --version")
  end
end