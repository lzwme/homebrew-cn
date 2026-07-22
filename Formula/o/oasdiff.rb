class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://ghfast.top/https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "60bec337d628536a49ff7229d8553a97862b4b5f111dc3da7424224700a3ac63"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1db338104231980db1a17a3b9357bb831304f96f3eee005d7bf8c5e5baa9e18a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1db338104231980db1a17a3b9357bb831304f96f3eee005d7bf8c5e5baa9e18a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1db338104231980db1a17a3b9357bb831304f96f3eee005d7bf8c5e5baa9e18a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad0806bd11cedf15b81d4fb0d12b39fd0b93592b8af252f739259d9084e0be5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "055f6657b143f7bb985cb5e89c6c8c81ae1b57f903c3d35f0cd34c3930fbef98"
    sha256 cellar: :any,                 x86_64_linux:  "6ef9a61a121863a07cf96849163d301227cc99ab18ee629d8f53fc8d49852d66"
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