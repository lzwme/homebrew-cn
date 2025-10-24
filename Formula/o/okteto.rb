class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://ghfast.top/https://github.com/okteto/okteto/archive/refs/tags/3.12.1.tar.gz"
  sha256 "16b8b2ac521c492a331f32f3f176655be64e5d14212922433ff683f3ece793fe"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3eba403e901de581034cab1d3e272eaabcda87dc8be4528db48062923d41e2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f4dbc9f3bcc091a5a39543378b2f8d1c48492ae69dade18a9b18082b0f5b6a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10408964f84246ec4c969eae297c141ef4527915d71540c8d016fe66cb6b97e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "1aaa3b78089ac824eeec85268c9adcfcbc193f00d0877ebc1a7d3a43716e398b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d5af84afeaad08b45ef10049fc779971cc0d5558bc2ea7025d9775185d4ba57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fdc6044930834a6a6829240d5ca9c0d76d779ea8042f2a0154088d210172921"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags:, tags:)

    generate_completions_from_executable(bin/"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Your context is not set", shell_output("#{bin}/okteto context list 2>&1", 1)
  end
end