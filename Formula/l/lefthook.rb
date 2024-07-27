class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.7.9.tar.gz"
  sha256 "3905c9ed67e960a48d84fe4e1918201d6227e1cbf0482098c0e61698efbf16f5"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "79d30315f00ed3ce7e412655c9b161ea1dbdad0b2fea1a379dd4b8a53318c2e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e005cddc0ade8c5315b06b41582539f5b98d58a0f40a9ea04231909a427213f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf03b50deb3cebdfa7a357de31622163351c4e33f222bb8a988bb7382aa0e5a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "99e650b66804e7551a17c7c75c79f9ce2dee8703ec00479d7b796873877d9cce"
    sha256 cellar: :any_skip_relocation, ventura:        "9685bac0f79f69f3c04be6895245d2beadbe8b86c4bc038b26c62262ab00b2cd"
    sha256 cellar: :any_skip_relocation, monterey:       "a53f010c8d1d5c3a8d0e7ac17b5816f0928b51277ea52ddd7ee0d1c3453cd2d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "caff5a06210558267d06e5718e4937be3e4f19cce5590541c1a6c79abd9ec7ba"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-tags", "no_self_update", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin"lefthook", "install"

    assert_predicate testpath"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}lefthook version")
  end
end