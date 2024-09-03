class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.7.15.tar.gz"
  sha256 "94687b66e07f4b06740ba3ebaefb8cf4ed79e2ba16c4451b2447cc7d3671a71c"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1cecde163b0f88f8e86f74de8462c6d4ffe1e068a0e8669796bdc658ca57a985"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1cecde163b0f88f8e86f74de8462c6d4ffe1e068a0e8669796bdc658ca57a985"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cecde163b0f88f8e86f74de8462c6d4ffe1e068a0e8669796bdc658ca57a985"
    sha256 cellar: :any_skip_relocation, sonoma:         "eb866094eaf022c32ab74b1f5189f2ddef65ec617f85d9bd9ab9f59d387659e6"
    sha256 cellar: :any_skip_relocation, ventura:        "eb866094eaf022c32ab74b1f5189f2ddef65ec617f85d9bd9ab9f59d387659e6"
    sha256 cellar: :any_skip_relocation, monterey:       "eb866094eaf022c32ab74b1f5189f2ddef65ec617f85d9bd9ab9f59d387659e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebb571a089bf086cc00b9a9f0fea8fbd0a0648e558510f11f306ec9f9443af1d"
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