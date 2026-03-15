class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://ghfast.top/https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "feacaf2fc0ff5a68ecfe5e2bcd955d44000dc1e50a003dd4eec7a7f33153fa35"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b241dedca25c4ad3713efa9dec0a1f0affd4973d27d2ea438e3ae9e9adfea7c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b241dedca25c4ad3713efa9dec0a1f0affd4973d27d2ea438e3ae9e9adfea7c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b241dedca25c4ad3713efa9dec0a1f0affd4973d27d2ea438e3ae9e9adfea7c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "75c8e2a8a4a6f182c0d499f9fad82c1a92cde01dd40b442e4554fa06f114a758"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c70a4d0085a678c1704d2daed27155c358b869cf8473a23bcd192ead092e836d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d720ebf2f8cb61eab55bf3772f25e6b23022c8bae58bb74c8530aa8f91e4c247"
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