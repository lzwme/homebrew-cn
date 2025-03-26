class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.11.5.tar.gz"
  sha256 "6918b6b6146e5b7c48597f045745a62d815c23b62ccb062554affef2607b836c"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7b0f16da65c411b583671d1202720dc5b7d2b94d1c708a984c988d2f9d9a03a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7b0f16da65c411b583671d1202720dc5b7d2b94d1c708a984c988d2f9d9a03a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e7b0f16da65c411b583671d1202720dc5b7d2b94d1c708a984c988d2f9d9a03a"
    sha256 cellar: :any_skip_relocation, sonoma:        "dfcf1e0c08c04e988f16c6bf229550f55cad2608f96a7505afc811ad0fbe93ab"
    sha256 cellar: :any_skip_relocation, ventura:       "dfcf1e0c08c04e988f16c6bf229550f55cad2608f96a7505afc811ad0fbe93ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "caed204a9e8c2ed42e5e116ef65e0edc3aee9e39c60101587c0fb1182c0241e6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "no_self_update")

    generate_completions_from_executable(bin"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin"lefthook", "install"

    assert_path_exists testpath"lefthook.yml"
    assert_match version.to_s, shell_output("#{bin}lefthook version")
  end
end