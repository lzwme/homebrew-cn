class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://ghfast.top/https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.11.6.tar.gz"
  sha256 "67a8e1380e1402ab1b98dd399cd3916751ab55b65ed1c86413716c0b85b79685"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f96df95002f5673217ad37eee635a2d46011c60b2445def707c556d1de0ae7e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f96df95002f5673217ad37eee635a2d46011c60b2445def707c556d1de0ae7e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f96df95002f5673217ad37eee635a2d46011c60b2445def707c556d1de0ae7e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fb9d225ddade86e3051d490c96001acbd15052d71e09a65d390c73ab10b5f4c"
    sha256 cellar: :any_skip_relocation, ventura:       "5fb9d225ddade86e3051d490c96001acbd15052d71e09a65d390c73ab10b5f4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb6884603c7538437a243e328b23eb12dd54386f6ae23c6401ff1d35483f074b"
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