class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://ghfast.top/https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.11.7.tar.gz"
  sha256 "bd06a38e62657634ab95ebc06174580fd3840fc07d8e5646eaed229d6dff424f"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80b4c7eb3e6a9804d2dc7ac7b2508e7a345c446037dd224e68b6563f30e9dbd9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80b4c7eb3e6a9804d2dc7ac7b2508e7a345c446037dd224e68b6563f30e9dbd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80b4c7eb3e6a9804d2dc7ac7b2508e7a345c446037dd224e68b6563f30e9dbd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c4341844285ca3ba57ebf4b790a12d67359393db372b607a848a4f61db0556a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0ba364544298d533a427f1624c64765a74aaafeb7c9df4afef731ebcf104d67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "574f188d914a8ca9740cca6d5fe86668720748aa29423fa754ca1741ff63c845"
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