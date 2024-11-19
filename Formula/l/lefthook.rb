class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.8.4.tar.gz"
  sha256 "e8e49bc5796f7cd035379cdb7df6afd335ee5687e6a6d4377a793e4fdc1cf467"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3da31658a6833384f60430499f46ca96dba9be6a0d95d4061f7055dfd82fbe64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3da31658a6833384f60430499f46ca96dba9be6a0d95d4061f7055dfd82fbe64"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3da31658a6833384f60430499f46ca96dba9be6a0d95d4061f7055dfd82fbe64"
    sha256 cellar: :any_skip_relocation, sonoma:        "d02938e1577380b84c2b66673464e0ca7f6fa6dc3eec2d94be5163cae274c789"
    sha256 cellar: :any_skip_relocation, ventura:       "d02938e1577380b84c2b66673464e0ca7f6fa6dc3eec2d94be5163cae274c789"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c06f9365bc4880de5f3c06957443405a2dd751f5035aea6513b58aff438628c9"
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