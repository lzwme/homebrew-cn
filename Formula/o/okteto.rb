class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://ghfast.top/https://github.com/okteto/okteto/archive/refs/tags/3.10.1.tar.gz"
  sha256 "f0521f5d7aa9588cd4bc8f94d26686022d489270d1555a580c150e1e50f9f94b"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51b7e46e6f92235f380681eca10b360087c176629aad4b5e764707f63cebbd39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d4a61b0a0b96ec397022fb9e71c68bb3bc242faf47622e326de1f283329adf7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af8fc8e7efa48d8a1ac431af2faf0499e910b0322e60f623c0aca78e2eb22dfb"
    sha256 cellar: :any_skip_relocation, sonoma:        "62e558b72a91ed7f322f87b293526e29068002b1ac3195fffecdff3bf588eda5"
    sha256 cellar: :any_skip_relocation, ventura:       "fa755df2df0784e52abdc671eb01165fe672f565955b3aaa930d455a55126144"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9debfa929c59733d91c7ac2ba9bd704c1aac4c595adbfb80ba2b2090a56edc0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3161c4c59eb2fb22897bb11307ba8feb351e1d5eaaacd35fce47b6f5cef05775"
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