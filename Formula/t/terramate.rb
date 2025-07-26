class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/"
  url "https://ghfast.top/https://github.com/terramate-io/terramate/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "ea867e1852545f3d25dbbcd89ee265880acaaaf86a5991b28e83f3763cf68ba7"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cfc310f827677e0414093542050da53c5a9da9e5c6b26a30a8344cc247de6cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cfc310f827677e0414093542050da53c5a9da9e5c6b26a30a8344cc247de6cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5cfc310f827677e0414093542050da53c5a9da9e5c6b26a30a8344cc247de6cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "8fc2d4fcfcad666552f4e69bf0ba907dac28b160c2f6e54e3c97ef1e85a2e414"
    sha256 cellar: :any_skip_relocation, ventura:       "8fc2d4fcfcad666552f4e69bf0ba907dac28b160c2f6e54e3c97ef1e85a2e414"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8772bb8f3ed859942e9b1a1d61253d9e4703d0701beeef45bc8978f2c99a329e"
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