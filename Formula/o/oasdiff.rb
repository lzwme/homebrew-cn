class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://ghfast.top/https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.13.5.tar.gz"
  sha256 "03037825bc65df21b776c46a7eab1073bfe60c3571d6acc02f2bc516d66cd09e"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15ce3b525f49ffc9f5b61f5ec4cba7fadddf24118b2f59d3813bcecd8cd85819"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15ce3b525f49ffc9f5b61f5ec4cba7fadddf24118b2f59d3813bcecd8cd85819"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15ce3b525f49ffc9f5b61f5ec4cba7fadddf24118b2f59d3813bcecd8cd85819"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1bf9dd6a30a4c1c152368cecb07d035877e7d7640248b4a6f59f07821cee9a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bb1b6af93ac3bc13067db3e3158548b86845986acb1f5efd7ff5eda82c73b13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7b08621e59251dcd7fb31ef8c4187a5659473c2156a07d7605fa0a98ea14e0a"
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