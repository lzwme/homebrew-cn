class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv24.16.1.tar.gz"
  sha256 "b561a8d9f3cf04c6a422de8965d9e184731eeace9c0bc5f2df15f3e9acc67e91"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30273ab656b4919979183164ef1351f9f5af8773217cd0218828242abc1ba973"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1daf63e43136dc8827b0323adc8ef2dfcfb108fbc28a6a7ad94ffaaf757eeb8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1de16fbbcec0faede4e9a40032b48e69721c754f60e0220a9c78676d78e7c1ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "9cf7b4403d2bb29fc8fd350425e0b3f7972df7324d36cb9594506f66c7054f36"
    sha256 cellar: :any_skip_relocation, ventura:       "b1221f79d2bacb711bf351f1cc139f2f524a94aa38be5bbfcb40507b4ac4e33a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a23374017387241ec31bfde64f92fa29a91a7964e0007bf95d3ec2665fb0ba3e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Version=#{version}
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Date=#{time.iso8601}
    ]

    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin"oh-my-posh", "completion")
    prefix.install "themes"
    pkgshare.install_symlink prefix"themes"
  end

  test do
    assert_match "Oh My Posh", shell_output("#{bin}oh-my-posh init bash")
    assert_match version.to_s, shell_output("#{bin}oh-my-posh version")
  end
end