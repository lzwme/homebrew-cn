class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v30.3.0.tar.gz"
  sha256 "6f61647366b35a3977fe0e91409d09f4bf6bf32a39094ab5a173949f443c4cb3"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1827a1880cf5e4dbe6db1531bf971910f31882b03935c25bb2bc72491a25f96b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44c4ddd1db2a2352ddddf6963eeac67e6de40ecb1440c7c7e948a1718ea1a95d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0de08921b52eda1fba87be5303a00eae4d2c2683ce8e73177b849aa63d21c767"
    sha256 cellar: :any_skip_relocation, sonoma:        "de0359618b0032bfeef40025c0a052f1e0cb25d914ecf8ccbb35d14edefb023b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9109728291660941bfb2964db66c20ab3f24d8732a5312bdab3e0214d89a0275"
    sha256 cellar: :any,                 x86_64_linux:  "3ef22408bdd7016f6753772350f60025f7e0ba4d40bdff28df072f864a5b2c0e"
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