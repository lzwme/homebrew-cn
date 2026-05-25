class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://ghfast.top/https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "195ac7145c56b1a029ec2dbe8d95f01b3f716c31e6596d4d13052d71e632de2c"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8b65f0de7773c0f40c6c1f40f0b953e28d122d0d3093f7b351ca4101df07ef9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8b65f0de7773c0f40c6c1f40f0b953e28d122d0d3093f7b351ca4101df07ef9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8b65f0de7773c0f40c6c1f40f0b953e28d122d0d3093f7b351ca4101df07ef9"
    sha256 cellar: :any_skip_relocation, sonoma:        "18ee6c72168d29e7d95b8d310db418fc246e33ddc7eff35a8ab133adc59a3929"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3437d4b7038c775cc7c811bb6c0a9281e8972db1ccc8698915a4e2f9285aab70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8f3937625e83affc1dac2f210c63e8453c1eeb1431b6388041798d5bda87fd4"
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