class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.9.3.tar.gz"
  sha256 "fedccb4704f28c136a2966e80ab22d8543bc028fc8571d1572a2a6e0884bce32"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ddf18adecafd74a0674f37e6b898a31f07c3596235cbc7506f8eb5fe067dd20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ddf18adecafd74a0674f37e6b898a31f07c3596235cbc7506f8eb5fe067dd20"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ddf18adecafd74a0674f37e6b898a31f07c3596235cbc7506f8eb5fe067dd20"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ebea994b8aafbf140f0546c33271526e7ae83a82496f373c534716fc5e98278"
    sha256 cellar: :any_skip_relocation, ventura:       "0ebea994b8aafbf140f0546c33271526e7ae83a82496f373c534716fc5e98278"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "709c3950bd9c6c911acb9c2ae12315599b4f4277b523e70ab4af85f6e9159ac5"
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