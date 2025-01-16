class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.10.6.tar.gz"
  sha256 "be4067c5d0a82a22341c1dfe0c33fdcaf66f7a2feb470c633c3a442a118d07f5"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5eece8fcd915e4200fdf4c073ec694f2e088ea0db1814f3146dfb7834c3f355"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5eece8fcd915e4200fdf4c073ec694f2e088ea0db1814f3146dfb7834c3f355"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c5eece8fcd915e4200fdf4c073ec694f2e088ea0db1814f3146dfb7834c3f355"
    sha256 cellar: :any_skip_relocation, sonoma:        "44c9d02e82bc4a88b8b9bb4137229b1dd61e05037f55258deb2bc85dadd7ad82"
    sha256 cellar: :any_skip_relocation, ventura:       "44c9d02e82bc4a88b8b9bb4137229b1dd61e05037f55258deb2bc85dadd7ad82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb50851e2ee15034367ef8e38d78cf9dd0583a7d3934f4d06cfef6f1a42532e0"
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