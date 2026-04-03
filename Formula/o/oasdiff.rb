class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://ghfast.top/https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.12.8.tar.gz"
  sha256 "f591d5c164a57842331ca5347d19e8c5a7af214787801aa424078f544f2e56c2"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70549c00785721b7522ec8f304de7f557d2b25a201cad9b5c335defa838f9ca0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70549c00785721b7522ec8f304de7f557d2b25a201cad9b5c335defa838f9ca0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70549c00785721b7522ec8f304de7f557d2b25a201cad9b5c335defa838f9ca0"
    sha256 cellar: :any_skip_relocation, sonoma:        "ced63abaa32f476aaa0a51092a0f0fbbe76a01541fa745a1f7e57eadbe1e5979"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6847d20dc719086f253a9459431c79706ed757ecfae9984d09e3916c4e1734ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fefdc347c4e4ae8f689ae7265a16a9634aecb1ba345e9179515b9ca34c66cccd"
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