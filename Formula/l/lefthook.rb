class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.6.2.tar.gz"
  sha256 "f2b61511a5b102c6f8db23189dad6f771d7abb2894882c133b8f78031f9a2c21"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "36df2142b5cb9ef55e3d83c3a638b79b0b5944bf8c4eb377e2d9e865f0ceb771"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50714e3f30f03c5c988cce27ec444b67bea8831e9f46723d64cee90ca3d810bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ed6ce87e07238320254c629e4c4cda0e0ca7c174262f7f1bc1551a68811c37a"
    sha256 cellar: :any_skip_relocation, sonoma:         "d6489250688354ad88f7009005f0fe864ba6359454ae8b6b3e312484a23d30fe"
    sha256 cellar: :any_skip_relocation, ventura:        "1c2a2f51a55914f2b63f143ab4f1baf71aba0c0dc5a0620cf12bd046088917dd"
    sha256 cellar: :any_skip_relocation, monterey:       "b85c6d2203308913433ad88ae7b97b91782574e4c666e6576bfa4a5456c0324c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b33a3b55c0e3c20ab8984f8f42383860b02501c060c65316873c1d638178752e"
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