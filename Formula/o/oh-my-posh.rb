class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v26.19.0.tar.gz"
  sha256 "ae6fcb76ed6d079e60f0b93882b7ee8482e55964e096d6779e930456c7fa3db1"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb4d772a761cba1e91dcf68fa7e7a306af71cf93b0ef4de057a96a3a64f15a83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a91dfe1010d7091b91e95dcf8c5548dcb44860d4cb035bb0641e7e372305dd5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7e91da85aa96c7dc6a9dcfedc97bde3e65d9a78a638d086b0edd7d076ec31722"
    sha256 cellar: :any_skip_relocation, sonoma:        "025218fcb9efc20720836e0ed91499441f421aff16b3439e00338eac47cd388e"
    sha256 cellar: :any_skip_relocation, ventura:       "f09efb1c8564e10ecd71b9445da90761535671bac3a46c584d79c865296e8427"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6341976593a452e8cbe685c2d02a4218ce9268544a13ae626c9ff11e30f3261c"
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