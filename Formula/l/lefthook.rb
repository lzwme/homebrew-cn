class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.11.1.tar.gz"
  sha256 "59527d3ffcf75c836efedf52657aa2a76c3b0b0db87a89d6db801f87819873c8"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b56cd87e1e6f11fffe057ae3681115085aa859da5ffb490d4805c2ee04483daf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b56cd87e1e6f11fffe057ae3681115085aa859da5ffb490d4805c2ee04483daf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b56cd87e1e6f11fffe057ae3681115085aa859da5ffb490d4805c2ee04483daf"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6cbf98eefb2c21f1ea07690759cc18974fea63d5848695f3a0e44fda3c44931"
    sha256 cellar: :any_skip_relocation, ventura:       "e6cbf98eefb2c21f1ea07690759cc18974fea63d5848695f3a0e44fda3c44931"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70c0eac9a2a60a854fba249880715e7ec89b89fb9bb0f04f875ada4281b76003"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-tags", "no_self_update", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin"lefthook", "install"

    assert_path_exists testpath"lefthook.yml"
    assert_match version.to_s, shell_output("#{bin}lefthook version")
  end
end