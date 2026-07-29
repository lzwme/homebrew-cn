class Treehouse < Formula
  desc "Manage worktrees without managing worktrees"
  homepage "https://github.com/kunchenguid/treehouse"
  url "https://ghfast.top/https://github.com/kunchenguid/treehouse/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "d68626da446824a88437ee7bc0f7fdd10eb507a8a0317bb210bc106ed85f480e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17587b11a56729717ddab23d932502d628effd2632efc92a56037a554284bc95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb0c6caab22784a70c19951718077b44728cbc8643635238bdf7ffe6a8677cb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd24dd008c6a67b991bdeacae0aef704594012977478fe51fb9b6a133d42e96a"
    sha256 cellar: :any_skip_relocation, sonoma:        "36f03e30e6f0e916bce3afa8e57567480e29cbe487ec64fa49eb04b07d8d93ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "077a4e5db5cb2e5421dd31e6ea46db5483075b074885c7e06fb055aa6ef82e7c"
    sha256 cellar: :any,                 x86_64_linux:  "d2f6af6b64cba4034d4b5cd52d6fe7f2a668dcaf1dc59faafa1a4f00cdefc78b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    system "git", "init", "--quiet"
    system bin/"treehouse", "init"
    assert_path_exists testpath/"treehouse.toml"
    assert_match "max_trees", (testpath/"treehouse.toml").read
  end
end