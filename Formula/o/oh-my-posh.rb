class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v27.3.1.tar.gz"
  sha256 "f305706615dbe299f79c1a2cba102bf6eeeeab2699cdc1f9279f49359759cd34"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d76d20f3384bce36d0797a38cf49dfe0a3bbdb90539d48c502e3228f1bc5ae4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "941235862569f2b3a8797b05e116a721e367b612de559532fffa0dadf14fcc41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fc47e9ec5bccd864f3dc8ae169dc12c257c788820d3c0d8738b5fec6ad708c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "d56043b6acd5b09cb5ddda29f416d6e1e4f553f8ce46637b3123c8a9f2e7b897"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58cd051f3c1fb4114db4699a39ce1849cc43806ec2596fc09446f07acd2dc529"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfe61f6471bad52e203331e5b6e98a40b12cae4af081eabaf24c9ce38790900d"
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