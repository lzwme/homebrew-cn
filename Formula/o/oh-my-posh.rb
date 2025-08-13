class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v26.19.1.tar.gz"
  sha256 "0eaeb914f2d71b49476ce0094983c91525651f1d39d70d4bbcc717c93a84d0a0"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f863c5a1095a93376110444344991e37dbef75213a0b00e789bf55df5c81f7c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6245523015236ce0e01da56ffe82189f405a3f0a2fec10f4f674a3269b32c5de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "387f473beb6a20284ca0c62e619c30bb2934403bae6bb242e0dd76941deba9dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "6bf908d72bfcc5d20e988a94197cd0a66bdb7b19efa8a47d4258922db669ee3a"
    sha256 cellar: :any_skip_relocation, ventura:       "735dca01a6d1e7045dc980dd25dcb6cf5a604d74c265f4901e55ce568b7e872d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e97237dfd957701db402aa74779188abe32fb50aee088bcf969b2bce1195fdf"
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