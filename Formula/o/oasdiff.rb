class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://ghfast.top/https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "e6cbab12470548920914ae45f900e9b8899ed0b6c692b98b1409f960d79e45f2"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a106b6c72a419e460ae36ce482a8bbdfbc832a7b5e985f80c72e1ac64b33e351"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a106b6c72a419e460ae36ce482a8bbdfbc832a7b5e985f80c72e1ac64b33e351"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a106b6c72a419e460ae36ce482a8bbdfbc832a7b5e985f80c72e1ac64b33e351"
    sha256 cellar: :any_skip_relocation, sonoma:        "efe171520f83bfa73c7cde8803e7aa3f38bacdf6853a776b84603d10e4f3a1a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3d265ae10a0ff838266d90aba470e15f4f797219e0765833cde6f26fe7118b1"
    sha256 cellar: :any,                 x86_64_linux:  "3a3d2f2abff78dfd4a4ea03e1542b6cd05ace72004c9c9a87179bdf393ebf6d4"
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