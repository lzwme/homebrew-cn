class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v26.23.9.tar.gz"
  sha256 "67103e8ab97bfa58ac2ecf3e1097b9cd4a49adb19efa1410c68fcbb268970dcb"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92aeba494491b901651943ea518e6a192b6c1c36e12f810ceb80c5aa1e847098"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf6660450bb0c3591d82aed6cb109d40952e768de92bb0623ba27357a89ae317"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10533b428b6c9cff8aebd66afd7bc4a7204b98d7f8f23ac5b4c52e5c3eaa232e"
    sha256 cellar: :any_skip_relocation, sonoma:        "92491ad973089a1f35e0f317fd86b00181545bc62bb313ea9d7919772c6136f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5655045ff053b84a77d76b11b944a6bbec4bd9e618b6971f6f9c507d029a33ac"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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