class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v27.3.0.tar.gz"
  sha256 "4a6764e0699e9791422b041e6d0e0994310d20a9dd8560b8d2c7fa3fb3c36017"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "139b498c753b6080111246a51438e162e790df39504d6a3b721d737e0a3b3279"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee952e0d11b8d9f1f251fedb75110e93e556eb18347f1c25d6a1a90e5cdec0d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e136608fe3fec5dd3c893b43ec1d76928e8d98b5d8b6b4bd7e04fb6378891fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "5caadd7266c532f036095b3ec235edf7bb32d17beeee394651d4d3a1a7ab78ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a97540f80f75b28e6661549525c57cfab319eae0f5d767db3704f7d106ee9e02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "848568f741a8d5bc41e80c98eef88dbf251698256564cde138f9f31d42e153b0"
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