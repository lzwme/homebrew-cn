class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://ghfast.top/https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.32.0.tar.gz"
  sha256 "a6760bdfee415e785192e9a329e1faf71a28d0fcccd1e43a6cfc1b880c88c966"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4f43198447b023cab4837f68fc997eb5797a8f01e4afcc50d3d157db56237010"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4f43198447b023cab4837f68fc997eb5797a8f01e4afcc50d3d157db56237010"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4f43198447b023cab4837f68fc997eb5797a8f01e4afcc50d3d157db56237010"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7befcffd87ca634e08d4c80c669066208b38dc452a27113c620606b687760591"
    sha256 cellar: :any,                 x86_64_linux:      "5ae2e5ec53700396b8d1d95a5df5ec5cdba31ec01fc559513ea1ba0dbbe5191e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/oasdiff/oasdiff/build.Version=#{version}"
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

    expected = "3 error, 1 warning"
    assert_match expected, shell_output("#{bin}/oasdiff changelog openapi-test1.yaml openapi-test5.yaml")

    assert_match version.to_s, shell_output("#{bin}/oasdiff --version")
  end
end