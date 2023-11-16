class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v18.25.1.tar.gz"
  sha256 "be2028a20d5d61df3e1769fba3c202ea09201681c9ee0c0f42dd9e91c81b14db"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af144e56a1ba98e4d01815c78579a25a40016c5fb980358a4e22de93b395105f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18eb89a11a98816a91c2cf23846741b899c7bb513e07aa852192a49d3707aa46"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "444498a19d49f85b1215f620c20ef6a0c5acdf12356f9ff4ababd649cfce52dd"
    sha256 cellar: :any_skip_relocation, sonoma:         "8275b4dc30f08903ac045243561ff4a21ac1e8f919301bf9d1a7d489902e9ff9"
    sha256 cellar: :any_skip_relocation, ventura:        "f2c949bdf9b05eb8dfeb215b8b5b5f50c53380e9c85e912dc0ea52aa4e278af3"
    sha256 cellar: :any_skip_relocation, monterey:       "ac7ffa148e912d05f06272baa54d54eafcf18b54f9c79fc7db3ba051664ae8ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a4db5e431c36716528c6ea3f77939c9b13e387223aa0e4c835397ccff28098c"
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