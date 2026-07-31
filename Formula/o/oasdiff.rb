class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://ghfast.top/https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "e0790896f57d2e8d812353a4b2811944b86ed9cad19b791a09d06854e7f7c6da"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bcf6e484116a47752bf663df3ad84bd2abc0b40afc31efb08eceb26bcccfc1ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcf6e484116a47752bf663df3ad84bd2abc0b40afc31efb08eceb26bcccfc1ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcf6e484116a47752bf663df3ad84bd2abc0b40afc31efb08eceb26bcccfc1ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "5bdc5a7a770268c873726d1a7eddc830f69bda806b32a9e2bf243cee4cc68218"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96d6686725916a8f0549a9ebd70ecca8f7924094e9bc8a01e64ed1cc5967ab32"
    sha256 cellar: :any,                 x86_64_linux:  "ff1278d90ff42a44e338e55a3faafe5ca4bfe5d7c8750700c4e820fa257ad21b"
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

    expected = "3 error, 2 warning"
    assert_match expected, shell_output("#{bin}/oasdiff changelog openapi-test1.yaml openapi-test5.yaml")

    assert_match version.to_s, shell_output("#{bin}/oasdiff --version")
  end
end