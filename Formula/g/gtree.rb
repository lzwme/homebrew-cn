class Gtree < Formula
  desc "Generate directory trees and directories using Markdown or programmatically"
  homepage "https://ddddddo.github.io/gtree/"
  url "https://ghfast.top/https://github.com/ddddddO/gtree/archive/refs/tags/v1.14.3.tar.gz"
  sha256 "11ad53b2dbb6bfda52ac24efb547bd62489e93420aa33c7213855c41cd7cc509"
  license "BSD-2-Clause"
  head "https://github.com/ddddddO/gtree.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b827aee48c23aab9b24a30afaa5561d0827440f617056c1e03134f4b6802dc23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b827aee48c23aab9b24a30afaa5561d0827440f617056c1e03134f4b6802dc23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b827aee48c23aab9b24a30afaa5561d0827440f617056c1e03134f4b6802dc23"
    sha256 cellar: :any_skip_relocation, sonoma:        "55ea46a9234883abf886214d15c61ae26be11a74ed4dcecd9d00d147e7544a44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0452c2c9c150ca087261db80ae184ac80e7a701ada5ac3907bddaba4fd4179d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d650a96e271973690a1b4f15564c5fc787b9fa22f3a8d3dea6ec4e9998d4c29"
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