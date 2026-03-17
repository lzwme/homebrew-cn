class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://ghfast.top/https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.12.3.tar.gz"
  sha256 "74424a0bc02f6399f43af99ff6edf34c925c004bb089667db33deefee37b7662"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b36d76d76e0628df10fd6e28eeee879c4c70d337bc43757c766e296aacdcb55f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b36d76d76e0628df10fd6e28eeee879c4c70d337bc43757c766e296aacdcb55f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b36d76d76e0628df10fd6e28eeee879c4c70d337bc43757c766e296aacdcb55f"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a40e9583d889530d59a2f6a6317de2be3e008c6c36f90a59f6cbc8722a21423"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "102dd79bfcc9bbf3dedc4120569a4bc26ca8562883b1c3443ccc7d1fab43a6af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15637a14e9da9c10fbb0333dea66be25438fd344b29bbb31ff0cf2da2a94f488"
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