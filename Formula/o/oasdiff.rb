class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://ghfast.top/https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.11.9.tar.gz"
  sha256 "588fbf7835d5d0464028ffc33191b98e1108299849eef5a2b97813addfae827f"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1138ef9385af4224a29f6a1a869ede7cd4f3ae4c4f7896159601f3b1416f5f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1138ef9385af4224a29f6a1a869ede7cd4f3ae4c4f7896159601f3b1416f5f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1138ef9385af4224a29f6a1a869ede7cd4f3ae4c4f7896159601f3b1416f5f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "5651b7eb8276c60c4c35eaf1072d72e9430630021f19139dcea90bfcd95c8e32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20ca23cfb98da4a23e949b3d97b3c1b26c2e11df44bdc5833caa9dc10b9667cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7601fb94b2b5244e5322093316c861aa3b14f386a6745dc286a4c0dda2a5034e"
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