class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/"
  url "https://ghfast.top/https://github.com/terramate-io/terramate/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "f88003cb161e1efaca3b524a64f27d8da8f330f944c571fd2b3f05eecb33496d"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c903b97e0231ce5d3439a9559c7b830b2d0fabc4ac32ef2ae95ba5a5b8a1e469"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c903b97e0231ce5d3439a9559c7b830b2d0fabc4ac32ef2ae95ba5a5b8a1e469"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c903b97e0231ce5d3439a9559c7b830b2d0fabc4ac32ef2ae95ba5a5b8a1e469"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb2f668b2940146dbcaa9f6882bf4a25621da209bb0ecc0ee50173c977d5785d"
    sha256 cellar: :any_skip_relocation, ventura:       "bb2f668b2940146dbcaa9f6882bf4a25621da209bb0ecc0ee50173c977d5785d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ead02ccb42ce129b8271bcb7bacdb1220bda3540dfb20ec725fa60fa4b4694f1"
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