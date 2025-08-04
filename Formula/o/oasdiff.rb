class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://ghfast.top/https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.11.5.tar.gz"
  sha256 "0e7c4c6c504d025ef2e44cb6bdf06d690d95e0b7639cccd40168bccc080357de"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed957def4093ea3cde0fc3ea694a0aa8b9c39fee3593d6e86f9fc35edea91b00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed957def4093ea3cde0fc3ea694a0aa8b9c39fee3593d6e86f9fc35edea91b00"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed957def4093ea3cde0fc3ea694a0aa8b9c39fee3593d6e86f9fc35edea91b00"
    sha256 cellar: :any_skip_relocation, sonoma:        "91ccced8d8795d9030447cef335b0ba4995cfe9fb26f1c0570d34be062b363bc"
    sha256 cellar: :any_skip_relocation, ventura:       "91ccced8d8795d9030447cef335b0ba4995cfe9fb26f1c0570d34be062b363bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "054a5f91994a1d9c80f607f9331077dd30ab35f206e8ef5b300f57077cf6a3aa"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/oasdiff/oasdiff/build.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"oasdiff", "completion")
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