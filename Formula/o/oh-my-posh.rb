class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv23.10.1.tar.gz"
  sha256 "5cabb694a5802ed2799431c90466e0807e1e4b1fb45625477d17d0cac2d51d33"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5eb0f7b8d87ccda7106f9bcb7748b61c5b7d9525e4d24b86d91e08d293dd80fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3685393667db7e06f0f29c8d31ce7083a03344d43406ae4744282b10f0adf669"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64b25d9bd8e56fbc18075f6fd58ebacb35ae384e7058f21736fbab4dd133e5fe"
    sha256 cellar: :any_skip_relocation, sonoma:         "f8ab432750c6fc4260f828782be83f9bcce597a8946ac62d1772fe71236e427e"
    sha256 cellar: :any_skip_relocation, ventura:        "c909dfec8b299e0c8a8723753e7a5ba83389fb271a4c54b94c8eae2ebd51f66c"
    sha256 cellar: :any_skip_relocation, monterey:       "55f9d6e9347b5da565bde9ea58f785924d036e310c2dc5c9677f6b33e1cef0c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a12979e47b4b790dd3ce441a5df07b6d8286a45c25496d54a9f141785fd3b4f7"
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

    prefix.install "themes"
    pkgshare.install_symlink prefix"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}oh-my-posh --version")
  end
end