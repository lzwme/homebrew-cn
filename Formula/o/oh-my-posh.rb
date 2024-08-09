class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv23.6.1.tar.gz"
  sha256 "eeafe60278232e4df7e2ced77e8a9cead8032e561488aab8dafb689b77eb636f"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa4435e10530e1fda02bcc36e49b48f8be7a8369cb5a639c1e8b9e21d863a9ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e655df588ddcf5eeca58be2ae185b008bb7424c67c1c244a515b068a5c1b443"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d7b00109f81e1c205ed2c81f380086f292a192a97aefa20bed007ee8f118e32"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ef5122a0c7ea1528318ab1960996b37029c9d49b222b588de1179374cbdf33f"
    sha256 cellar: :any_skip_relocation, ventura:        "d9ace38a9b383f49d8e5e749ce66d63941bde70f3856c8e31e16a95e149a26c1"
    sha256 cellar: :any_skip_relocation, monterey:       "997b376ec51ab1cca8d55ec7d46106ed73800b7e929a34d11515b54780a1268f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3021c6de494266ce664d8ebfdddeefb068820b19ce47c2dafd881a53be50e142"
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