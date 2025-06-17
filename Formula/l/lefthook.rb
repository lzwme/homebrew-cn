class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.11.14.tar.gz"
  sha256 "583188013f3731dae5c24c0da5db19752042e56694f5537484bb7d9233b4d9f2"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86204823c07b3f343a5ba99cef733542c2dc47efc5d04a5f0c2c70474716bee1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86204823c07b3f343a5ba99cef733542c2dc47efc5d04a5f0c2c70474716bee1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "86204823c07b3f343a5ba99cef733542c2dc47efc5d04a5f0c2c70474716bee1"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fc7dc8b084aada495b7b4ee8261518fe94d43def01eb952fe7ab9876d20ad0f"
    sha256 cellar: :any_skip_relocation, ventura:       "1fc7dc8b084aada495b7b4ee8261518fe94d43def01eb952fe7ab9876d20ad0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10d0b3c06a41606777735d58b242c34ee7d419e35909bde74c9ec6e44cde6e17"
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