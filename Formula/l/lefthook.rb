class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.9.0.tar.gz"
  sha256 "24d81c6efaf4a7f75a1c08082e4c1b84e9bb75b7276713904b359634c5abb6e8"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ee53f8026e060991e3cdd7b87f79ab2a16043e21aac41b8ea38c04b7e7481d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ee53f8026e060991e3cdd7b87f79ab2a16043e21aac41b8ea38c04b7e7481d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ee53f8026e060991e3cdd7b87f79ab2a16043e21aac41b8ea38c04b7e7481d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "d728ef1bc57e5d19068849e409a8c248c82c7d0d12690e890ec4cdb679ef2ff1"
    sha256 cellar: :any_skip_relocation, ventura:       "d728ef1bc57e5d19068849e409a8c248c82c7d0d12690e890ec4cdb679ef2ff1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1107de58c2daaf9ac251d9efe9462df51779b8dd5f8d34da3bb8fbd1365d75f6"
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