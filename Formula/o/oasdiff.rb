class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://ghfast.top/https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "8e70976106505585db641ff7d575442f6760d8ff8538e383f122a34c1ddc6e11"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a86a46e70b80acbd115d365e02f240df35ce6fab6c0e8530efa3c590a22a5bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a86a46e70b80acbd115d365e02f240df35ce6fab6c0e8530efa3c590a22a5bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a86a46e70b80acbd115d365e02f240df35ce6fab6c0e8530efa3c590a22a5bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f8ca91c0cea8524b6629feb8947500b42bdd1de37b2fae3a48ec207c1bdb184"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae763aa7b4dc1e8ec087b4c9ad7cb51532683a60e67e1fc90c82d7820cc242b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "400ef84cb79c6d682e26a62f8a81236d5333c5b0f2056138f6c74c898ca05842"
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