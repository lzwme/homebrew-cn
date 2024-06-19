class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv21.13.1.tar.gz"
  sha256 "df7f0f61cb5b8a50ac7a915fc64d40764df54df8b2526638b0a41ccd5bc0f316"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c4da82db62369f7933c6d1d4573664445177e06a2f3235c29088d60ecbaf0d3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05963bd4e247fea784f25575bcd3918e4b4913f7ddaa95c8d570121d5962fbcd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "736faa9b98614e2ae9a4b52edb2bd6007299eafb06b327640100f324d53bdfd7"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a18e5ad114b83caaa080b0152813833c27d82b1351af73e40567d524f3c7d65"
    sha256 cellar: :any_skip_relocation, ventura:        "fd205c935bf796da9c2368c155a8ad22d11cb43531e68ca2a42a548479332eff"
    sha256 cellar: :any_skip_relocation, monterey:       "de697a643e91e1f51217e54c72164529b019d7723ffc06ead98125d2e7ecf87b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05efacfa7eaaf61ac3ae537437fefbb6f6fb79cc87243016ad05c2c791fdbb21"
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