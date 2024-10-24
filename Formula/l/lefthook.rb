class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.8.1.tar.gz"
  sha256 "fcd86e83863e6decd60a60d19020d321565f60ac5b147afcb9f7361cf771c4ed"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed0a6d4504912c4bb8e9824d0d5fa1980c122a6daf1e2f9da4ea2f59f5712687"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed0a6d4504912c4bb8e9824d0d5fa1980c122a6daf1e2f9da4ea2f59f5712687"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed0a6d4504912c4bb8e9824d0d5fa1980c122a6daf1e2f9da4ea2f59f5712687"
    sha256 cellar: :any_skip_relocation, sonoma:        "9983815303c4f2966ac1320d827bca7b23dc637260fb8e2f909d30bfda37ba70"
    sha256 cellar: :any_skip_relocation, ventura:       "9983815303c4f2966ac1320d827bca7b23dc637260fb8e2f909d30bfda37ba70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02da3d784d9ac391f48aad35a94d6cebe763563865c57a213628f7d29ad243e2"
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