class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.24.0.tar.gz"
  sha256 "736cb0f40ffbbbb2cd945f9e50e79e53f11b1f07bacb4c6b4ab1b2f28f8cf874"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3a307b2cf35cd34d73f150648181be5bb953e67ab2920f695539ed066670b6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c9a189719fb65dff3e5627f78f7e5e8294f027fdd3f6ba99769aef14d216454"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d34f0cdbf1aa6f15e240d9837166fb4d49244935dbb67fe1416ba56a4cb2dd4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c9068d657237473f6c65c1feb21fc7735e841690c1e2b009c41bb0ad6457757"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb43bcf2c5a1106eb4883f5d03ceef45c758a052346ca8a4a286facafd1b6978"
    sha256 cellar: :any,                 x86_64_linux:  "ef7427b6a9c747aa0e1773c0544fdb0ddff3905e1be5f2171208989617dfbc96"
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