class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://ghfast.top/https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.18.1.tar.gz"
  sha256 "55e69b83d75be4f9a9779e0ed04a68247d9cb80cf51206b9f96c8ffde090561b"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8645e4b5bad45dae329070fa452c248292ec42f3bf51f9d881a1e62703555e86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8645e4b5bad45dae329070fa452c248292ec42f3bf51f9d881a1e62703555e86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8645e4b5bad45dae329070fa452c248292ec42f3bf51f9d881a1e62703555e86"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a4b4db6097c8e171e3de1b9515d51388a34ffc408f66905820c05e39eae58ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "767222eff3d0c5bd8995bb0f3f331e05145f185f5079e22c7f1a926e9411f623"
    sha256 cellar: :any,                 x86_64_linux:  "1dbecacbcb1fdf6cfe4428469f9ef36d72c4fb181b41ffafa4cf47de1d5f3bbb"
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