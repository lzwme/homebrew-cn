class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v18.10.3.tar.gz"
  sha256 "c7c4f464f40085118dd124c4f947a7f83cd3e3f1ab310229abfe006d41ac903d"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5f3a3ff66fd4a2718f1c29841393bdab4da4449c617ef52b1ab7f74a201086a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91568947b535a3a4afe64e0ad6a9ad2a3bba11e41a4b3a83ee9b197592be3932"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5d9e0f526334c9fdc86c789c55fdbe311f952c78431e4025488359381637a98"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e212174f5e75c7283c96fab11f3d608951fd78c6478d3ef585488b54820e5ea"
    sha256 cellar: :any_skip_relocation, ventura:        "a2227748bf688c08b6e79597b71a65f61fd4642ceb4cce51f3feb3c4a7caf1c7"
    sha256 cellar: :any_skip_relocation, monterey:       "1d0b3e44fa9a2fd89248c275965e8b10ca89eea91569384a584e43d5162e5a7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7daf2c01e4c1d3d14b2814b62e0472e862432178b44f05d9c989ca87166413a1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end