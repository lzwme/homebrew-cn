class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://ghfast.top/https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "27d079039574aa1cff3b54934fa61946a0e55ee18ca08fa3234b355a857eef9b"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6fbb706a1a36cf4e98dda80936511f3e4391dfe50806fd1212f317b1b16f9d3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fbb706a1a36cf4e98dda80936511f3e4391dfe50806fd1212f317b1b16f9d3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fbb706a1a36cf4e98dda80936511f3e4391dfe50806fd1212f317b1b16f9d3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "05ab340573bf6af17a3cbbc4d1438ddd23dddec48089a42892d9a4d1322f054b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c14f57f287ab338e066c27c12b37f4ee629ee8c07840a33a292e1437762ace1"
    sha256 cellar: :any,                 x86_64_linux:  "1f08a5d1ae6a572dc346e1411f31da8085fd720e343f8be70d53553dd1a5c9e0"
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