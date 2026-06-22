class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://ghfast.top/https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "710654aeff1d32dca5e54e494533ffb1210ceee5cbbde4cc10845449cd644c27"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d712de5ef77f06d2f4bc1061961cf0b75d30d2ef499321ad9fa2a209465f79b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d712de5ef77f06d2f4bc1061961cf0b75d30d2ef499321ad9fa2a209465f79b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d712de5ef77f06d2f4bc1061961cf0b75d30d2ef499321ad9fa2a209465f79b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d938fd4e5a85cb972d74980dc4a773a891cf31b9f02920e9b8c697fcd3d97cee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1f9e5a358f4fda9f201489403766d9823f0034095a763d7bf90797699cb0ee7"
    sha256 cellar: :any,                 x86_64_linux:  "f3c15a2ca6df582435385e42952d1adca58e56a5b6b9c897cd6fbce0e268fe45"
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