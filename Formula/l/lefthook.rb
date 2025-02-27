class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.11.2.tar.gz"
  sha256 "2362a632eb66e34c8ae0e440b35b901a024fcf2bb85c88149d77826e78487ebf"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b1cd72550b8bf23d98257474c6975f74bb3ffc5c881c93ba0ecd00a20caccbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b1cd72550b8bf23d98257474c6975f74bb3ffc5c881c93ba0ecd00a20caccbc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b1cd72550b8bf23d98257474c6975f74bb3ffc5c881c93ba0ecd00a20caccbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a360caaec048121e5b611baa0943b2a304b06b2b16d1a1fa8f50cc88deb3d69"
    sha256 cellar: :any_skip_relocation, ventura:       "4a360caaec048121e5b611baa0943b2a304b06b2b16d1a1fa8f50cc88deb3d69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4e18023533e6755b9657730f495be3cb30ab4b39da113b2bd6e257ecb7a6269"
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