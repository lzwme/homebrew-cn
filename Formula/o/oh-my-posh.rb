class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v30.6.3.tar.gz"
  sha256 "5e309cf904f8214bfa77fd656395e058abf4c2a167e3066d95a19cb32fe6a320"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f973f311ceea635ba182ed6128cc40044a904ea07741f1582f9f569fca9e2f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af0a0a8c92dfc7ebbdffacca223f91b868cec7df2800c474b340fd0caa6e22fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c496ab1e9e455a4da8fe8120bb3397c3d368f4a609d86963bfecb1a00f4b115"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fd92c38a9d86be31b101e8960efe34af967b496276f2bae651404c331e98fd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9da795603928b66e4aaafb4f671cb1ce70bcbda2603934ba9eb3d7d43ec4bf7a"
    sha256 cellar: :any,                 x86_64_linux:  "7fe4791b0c709a2509823fc2d589591a16377d87e0ea4f1fbf9794e563135332"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]

    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
    output = shell_output("#{bin}/oh-my-posh init bash")
    assert_match(%r{.cache/oh-my-posh/init\.\d+\.sh}, output)
  end
end