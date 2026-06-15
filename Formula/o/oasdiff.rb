class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://ghfast.top/https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.19.1.tar.gz"
  sha256 "7062c866e3bf1ea4e0089bacc6515425086b3818eb17ded29497927348be21a9"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ccb6f838c49b6a028d521eb5bcab3638de1f37a033264843b0286018f228f74e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccb6f838c49b6a028d521eb5bcab3638de1f37a033264843b0286018f228f74e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccb6f838c49b6a028d521eb5bcab3638de1f37a033264843b0286018f228f74e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3aca3edc9ac39451ff94e3fa24076502bed32707e5caa1aa2126f4fa9a77f4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6bdc1a5b996b31c1080173ddb1c6f4f45a054cd14cbc3d08336ef39cee954ca"
    sha256 cellar: :any,                 x86_64_linux:  "b4cd2e1d86faec47e223c024303ba09b742ad44ac699948d6699694ae8492b0a"
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