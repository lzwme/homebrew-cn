class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.7.17.tar.gz"
  sha256 "4ffe9d8d294a51adabd77363092c6e684c9b4e45b7bd58f6a356ec6e76852a5c"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f52ebb3bf03e0902bb6911de90fc18d64a3e9094b2d907bfa696c6cfed50f9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f52ebb3bf03e0902bb6911de90fc18d64a3e9094b2d907bfa696c6cfed50f9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f52ebb3bf03e0902bb6911de90fc18d64a3e9094b2d907bfa696c6cfed50f9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b539a798ec52cc24ccffbadd12a4fecd0cfeb57a2ada82d828285d638d114ba4"
    sha256 cellar: :any_skip_relocation, ventura:       "b539a798ec52cc24ccffbadd12a4fecd0cfeb57a2ada82d828285d638d114ba4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2b712727b726e9af69d9f84899385f7e243c432bbff934735ae1e6a755342b8"
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