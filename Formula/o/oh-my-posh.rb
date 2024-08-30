class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv23.9.1.tar.gz"
  sha256 "21711cdc29092101b54712fef2692f77b38e3cffde33a4e218ed30a039031338"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f8421dbc844fdd355cc808d6c2b94487b0ee84193c0e60189a5bebb92b9d3a57"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "742b5ba024efe9e96a78878472622e86258006c6682b30760fdbc96de19b20f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d381a384702f78f02a26adabbc4d87fb77e80833ee8a4323dfe3bcf020ff5165"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f6b656a7efa0257e098403093b74092a813c23ea5ff45cb647a47aaf2c78a0f"
    sha256 cellar: :any_skip_relocation, ventura:        "c313d794d4219a8ca19aa8694349f6a2c7f7ac841de260f1af7c135736f0f7a6"
    sha256 cellar: :any_skip_relocation, monterey:       "47bda443afbc220e692ab8f478d812dcb73a662b5d752820599c88af48b37e19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "611ebfca3911ac1e6a8c84457bd993ef77115e60744f4243c981a1c7924711e9"
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