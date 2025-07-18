class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v26.16.1.tar.gz"
  sha256 "266d5a46c59064679e1d44b9ae5870b0fa478aa914aed46df3c68c36a6313935"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0818476e9a7849f6b00203c8ade03acc2d3dfec92aa6d1ffe91e169d3d29ac7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9f92a02016f8911a67465064eb3c627c26becf8aebcc6cfce1ecdf64025b925"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "188eea5c6b19a44b1049e3849ed8e5fbed52c73f26150323a41253dd69237c13"
    sha256 cellar: :any_skip_relocation, sonoma:        "b28c8d8e8df93b2dd9e6212ef98c4daf35f5bbc284a087332a6123b7bfa168bc"
    sha256 cellar: :any_skip_relocation, ventura:       "a60cbecb20a177cf9d779868c6f9fc00e0bf00081a9c68ec35c8bf1ed55e406e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d952e1bc8573a6d872a563228f49eebbd37615cd4e366f7e84cb3d7a35dfafe4"
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