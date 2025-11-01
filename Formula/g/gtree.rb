class Gtree < Formula
  desc "Generate directory trees and directories using Markdown or programmatically"
  homepage "https://ddddddo.github.io/gtree/"
  url "https://ghfast.top/https://github.com/ddddddO/gtree/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "fe4e2c8d1acd57eb7e0e15c9ffc79563f82721fcef4e54311745082d6a3adf69"
  license "BSD-2-Clause"
  head "https://github.com/ddddddO/gtree.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6dab5cf8e9d5a5b58d4b81151e893f41064a24f198d872002f65ee4c2ad3b7d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6dab5cf8e9d5a5b58d4b81151e893f41064a24f198d872002f65ee4c2ad3b7d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6dab5cf8e9d5a5b58d4b81151e893f41064a24f198d872002f65ee4c2ad3b7d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "282d901599c30b7f2cfcadfd19cc81807561306d17237cc4d6854bb80e173c11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b51e7569c9566148c3c722886171f6bdb039c24f2fc0e4b1f00320d034e95170"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "264c545ece9cbc725b439c8511ba4bba457fc7ffcd9a66b7637b8ad0dd3a24f0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Revision=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gtree"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gtree version")

    assert_match "testdata", shell_output("#{bin}/gtree template")
  end
end