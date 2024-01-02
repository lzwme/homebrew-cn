class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv19.3.1.tar.gz"
  sha256 "c0b8b75ed1a51b2558aa5db39c7c0004495d699b4e9dafa1393162819d510b26"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e9e64d95abc1b95a58f25b01e7f070b57475dc04cf7dc7ae4d7cedaae97676fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2d4afec6c01685da86879a36aab4730b014c255474138a555da51b67a36fc3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac6918cc214a09502adaaa5f25f31f8777a187c2cc98422e3432d662fb8f0902"
    sha256 cellar: :any_skip_relocation, sonoma:         "c242b4af1833a8a9c09d13a9fc31c0f3ee028120c60a98de90dd0df621656934"
    sha256 cellar: :any_skip_relocation, ventura:        "a25edc71033326fedf5a6c46c809d8b1b83d58bf73fe79f17e1a2d673089de1d"
    sha256 cellar: :any_skip_relocation, monterey:       "9a0e87af968f89f42e39bee9a0c96076b15b56c9da7bc01b25372624e0efc5ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19942fa8fd1108ed60db3e904b7211c5c2f04a9066d14ec5bb8a043a322abb4f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Version=#{version}
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}oh-my-posh --version")
  end
end