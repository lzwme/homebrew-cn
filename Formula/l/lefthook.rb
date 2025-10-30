class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghfast.top/https://github.com/evilmartians/lefthook/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "87c8658ddfdb125d88d123f2c2919e83a8143865dcb2f41b99a37011d444dd9f"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3052db4fb85e25b7977fdbbed7f4da69f09dd76d4c16e0d935a5b686a00838e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3052db4fb85e25b7977fdbbed7f4da69f09dd76d4c16e0d935a5b686a00838e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3052db4fb85e25b7977fdbbed7f4da69f09dd76d4c16e0d935a5b686a00838e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f54904383a39e1f58a0dcf455eb44db1ed88d163f0029bdcec3ce7bf8c38a665"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ca8d0ed7f60081450211eb99b4e410cc43ad260eea3a0287abe06a3957dfc49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05deb6a254605501128edc0716c1d2ce6397858af3f035de8a74d6434839b838"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "no_self_update")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_path_exists testpath/"lefthook.yml"
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end