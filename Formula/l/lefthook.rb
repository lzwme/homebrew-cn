class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghfast.top/https://github.com/evilmartians/lefthook/archive/refs/tags/v2.0.7.tar.gz"
  sha256 "edf4e3025809bdc459c6e400ca8e198c2d2e38bdf154c3c40196bb9720257206"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a550f6edc567a5258447d5aa5b5bfc9f0e44e56a98c42449aeebf6a6295cff1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a550f6edc567a5258447d5aa5b5bfc9f0e44e56a98c42449aeebf6a6295cff1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a550f6edc567a5258447d5aa5b5bfc9f0e44e56a98c42449aeebf6a6295cff1"
    sha256 cellar: :any_skip_relocation, sonoma:        "af150bd11809ac6de3f29d24f7843f352ed848d942b958eafa4a7f4b95cd07bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9925e08a01f04cd94959da39eb7ccccf8be548f88aa6c99777cfb7d4ca007012"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2aa1848b648c3c39acc02d97bfee3ff78d5471326e95231f521e2efb4abef270"
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