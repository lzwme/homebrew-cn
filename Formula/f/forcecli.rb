class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https:force-cli.herokuapp.com"
  url "https:github.comForceCLIforcearchiverefstagsv1.0.7.tar.gz"
  sha256 "f3a37692bd5f1dcf842ed3d917523b13c561ecfbdfa5170f4e98789c6472d762"
  license "MIT"
  head "https:github.comForceCLIforce.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68854eea2fc456c4ad3a77ec09939f694c797bb5785d200b41c1e007c906a43d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68854eea2fc456c4ad3a77ec09939f694c797bb5785d200b41c1e007c906a43d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68854eea2fc456c4ad3a77ec09939f694c797bb5785d200b41c1e007c906a43d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e99e1e3fa57c477ca3087020dde0a5620d341d70ddcce86d0d9ec969116daacc"
    sha256 cellar: :any_skip_relocation, ventura:       "e99e1e3fa57c477ca3087020dde0a5620d341d70ddcce86d0d9ec969116daacc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed2e3bcd665667d01a8aa278a47c4d7be64c53c4185980887e968e382c7ed684"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin"force")
  end

  test do
    assert_match "ERROR: Please login before running this command.",
                 shell_output("#{bin}force active 2>&1", 1)
  end
end