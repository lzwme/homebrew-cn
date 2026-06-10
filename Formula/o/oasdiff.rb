class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://ghfast.top/https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.18.6.tar.gz"
  sha256 "6e5ab4472e114fe0486856adb50cb053da043cf3493e6112af0f98b48ba17229"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a486a0cc9dce24b883da3296f4f2ff778d6633d4bfbf0a75c727ebddaf18b464"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a486a0cc9dce24b883da3296f4f2ff778d6633d4bfbf0a75c727ebddaf18b464"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a486a0cc9dce24b883da3296f4f2ff778d6633d4bfbf0a75c727ebddaf18b464"
    sha256 cellar: :any_skip_relocation, sonoma:        "d80b5897233d0a2138db3ce14c5bde35e17cb9c1aea1ce9f40b902d46000a133"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "867be2bbd11e35da10ee62c6bea13f3686d66ac31a05ddc188442ec3d4d0221d"
    sha256 cellar: :any,                 x86_64_linux:  "a3ee763091c0f34a87c1a811c496a68b89be04f4d8584ef3fda0ebc92ee36d09"
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