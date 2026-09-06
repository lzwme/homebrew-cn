class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://ghfast.top/https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.31.0.tar.gz"
  sha256 "206b678c498d8ff0ba15becc7a6afe116ea8cbc76528f75b6c048366a78ee9ee"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80228fd72372de1b1718344249b92d61a0981312d82be8af6aa69eec7033ba28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80228fd72372de1b1718344249b92d61a0981312d82be8af6aa69eec7033ba28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80228fd72372de1b1718344249b92d61a0981312d82be8af6aa69eec7033ba28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ceb7ef5b1e3f33d61f056b27b292778124697b91f8f81e4d7d173b9ac2f77c57"
    sha256 cellar: :any,                 x86_64_linux:  "5f61eb7a4bd101b9f653125426ca3bf929c95a0834471aab8cc7c7ed08224001"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/oasdiff/oasdiff/build.Version=#{version}"
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

    expected = "3 error, 1 warning"
    assert_match expected, shell_output("#{bin}/oasdiff changelog openapi-test1.yaml openapi-test5.yaml")

    assert_match version.to_s, shell_output("#{bin}/oasdiff --version")
  end
end