class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://ghfast.top/https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.26.1.tar.gz"
  sha256 "5496e1115dde112f3b9c902d73a94418c6e3cda391c6e038cd00cf8457d399af"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78e5183f723e14759a3a1dd06cd10305f05baf6f85ae4f82146579b95f88b687"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78e5183f723e14759a3a1dd06cd10305f05baf6f85ae4f82146579b95f88b687"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78e5183f723e14759a3a1dd06cd10305f05baf6f85ae4f82146579b95f88b687"
    sha256 cellar: :any_skip_relocation, sonoma:        "776bd28dbf73c80cef41d1b7093b77a2bddf484a937cf51839ba3ae469b8ec74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "720c94ff45579bd80eddd4e1200209993bb3cd7ee359fdd9ced2abbab1783e57"
    sha256 cellar: :any,                 x86_64_linux:  "fdc24e101cb9ccad2ee7af01af2a40346d3100638f4cc0d55eddbb1f158f0f44"
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

    expected = "3 error, 2 warning"
    assert_match expected, shell_output("#{bin}/oasdiff changelog openapi-test1.yaml openapi-test5.yaml")

    assert_match version.to_s, shell_output("#{bin}/oasdiff --version")
  end
end