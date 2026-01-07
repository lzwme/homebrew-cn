class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/"
  url "https://ghfast.top/https://github.com/terramate-io/terramate/archive/refs/tags/v0.15.3.tar.gz"
  sha256 "f0c5b5ced761184d0fe915174b1eaabc2888761bb75eadad024821960b6a787e"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a9645556058a6de1d02f3a415ea5c8e88cecf8575055d75c3eecadc4b5da8f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a9645556058a6de1d02f3a415ea5c8e88cecf8575055d75c3eecadc4b5da8f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a9645556058a6de1d02f3a415ea5c8e88cecf8575055d75c3eecadc4b5da8f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e5d89a1f689f07888a50c87054c12e444569cab9b51e8bc60448d4e04c3fa9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10ecb372d506dd300df5b8f4efa768fd44da98c0bc03f521443989b4a4c57ac3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5be955c44bcb98097e6dcb1b48ff819a10d476a9be8d828846f94d46abca0c35"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terramate binary"

  def install
    system "go", "build", *std_go_args(output: bin/"terramate", ldflags: "-s -w"), "./cmd/terramate"
    system "go", "build", *std_go_args(output: bin/"terramate-ls", ldflags: "-s -w"), "./cmd/terramate-ls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terramate version")
    assert_match version.to_s, shell_output("#{bin}/terramate-ls -version")
  end
end