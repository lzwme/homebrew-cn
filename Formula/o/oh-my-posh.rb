class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v26.19.2.tar.gz"
  sha256 "cf2682cc13d2e81b07909b36f52b57166a083825a94fbfe3a874fe62f32e7b3f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e265d9d53bcfb0890670163dbfb54974f324c59c9ed12ccc946250560485a680"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "043c007d25d46c76dba2651db0614e99b4bb5b359084e1cdd407f837c7a8a2a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d649a151c21462e8ff14a72081d40baf4ce14ec424298adfc1d7144efea8b321"
    sha256 cellar: :any_skip_relocation, sonoma:        "512daa2b84716ba163ce328ca0ad64aa2fc03374e959e0439a153d1cebabff13"
    sha256 cellar: :any_skip_relocation, ventura:       "1c73292c4acaaa3544d176c284ce129dcd8a2f9e283ca37b4106b5efd4c5de41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "943917eb7b604b0c1f3bf75a80939ed55363a1577b5272fdb545c9687fc57d9d"
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
    assert_match(%r{.cache/oh-my-posh/init\.#{version}\.default\.\d+\.sh}, output)
  end
end