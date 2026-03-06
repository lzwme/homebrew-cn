class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.7.1.tar.gz"
  sha256 "bbad9d58bcbda69cef1562b3d433861d31ca31cab67ba555c0805fd73fb73c87"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb9286e66b3e46f6c4132b0caea50eaa99e008c2a75bde7a16a3b2e7235260a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ccb24f5b2bb1bd9cff03bbdbee6bad5ddcdfc3bbe2a72c9ab6d280a65e1ecfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd9ad5d5a45dfe075ac1d45e5eb849b1f70d9d088e157cf13db0f7b4da2a1d41"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a8ab1f07f332107f04d0c7098a012485c0338e5e362b759874c2d9db07e5e0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "191c0ec7892353e7ef5fcd617e92c4bfb5dfc0b2aad161f4c51497e57557697a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e6559ef1ffa268b1be0c625688ec718e5f128f4e76914a761931adecd864d59"
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