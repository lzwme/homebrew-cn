class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v19.2.0.tar.gz"
  sha256 "33384db1100280b7592be4de442457c2c7dfe7f94823765f93ba07cadc5d64f4"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd7db8fa7c3e3cadfeb53eb64a0df7af1aeeaaf901a348cfbb9e1929c7edc4e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7dd307b7bc0daa7e0b129f3b422f8818479e4c48c93d45e9abedb47bc19927c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "775bd6bf3c85e12f2a4b9238212b8ec460aae23e08b06e7ba5d3361091948c94"
    sha256 cellar: :any_skip_relocation, sonoma:         "4acdf8e010c2d423b88a5e75dfdfb59d2fb87b47a227f7211c639b417ae4caf9"
    sha256 cellar: :any_skip_relocation, ventura:        "06ef3ccf0b51bc0e9488d3e2ee716ab55c4088b90cbe53d8727e818d15f28e98"
    sha256 cellar: :any_skip_relocation, monterey:       "653af7a46d0da81163efb0c77f98e6effd5798b8ddc34dbc084d829b77d04c94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "517be8a24b36fdca94161133db9bb7f460df57d3cdeb175a48fe0a11968daa30"
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