class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.5.5.tar.gz"
  sha256 "0065b2cc32aee190fac936d12e50e46d950be6830ddfd848ab27da9961bb3d87"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "46fa47d85a5b70845cf4facafc40883c6f02473724fe48a61f9b98e2cdd7c309"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d381015a06ab08ae3dd328cfcb4683215699e6efdb18a74c69ebd84e5433cf58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16624a5852627583af967fce9da0d857999487c34e0740a326753cc992aacc1b"
    sha256 cellar: :any_skip_relocation, sonoma:         "7eccad4e4150094398e9119096ea82dadf9f15b57c491826372e8b49d8b3e0bf"
    sha256 cellar: :any_skip_relocation, ventura:        "cd7a58cadfd2300e8b6a5ecf875e1225d5e422fe68c63ec07ec110801959802a"
    sha256 cellar: :any_skip_relocation, monterey:       "d4173e7192a036f62f2027e443453a93288b5cae09d3b103e108cf45f3bfe9e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e204b18efafeb029315b0f170dbc7099053dba1e1f7d9458d8e95c49403012b2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin"lefthook", "install"

    assert_predicate testpath"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}lefthook version")
  end
end