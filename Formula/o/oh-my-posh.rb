class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv19.30.0.tar.gz"
  sha256 "8951e43902c6d97a430e83fb767e56a99489b45ad464267c69a736bd09392c2d"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb455ba1da7c9977f04ed904f0f7b3d8c20b6d53866618311a294ed41b4194ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d59caf7b5f0f565456dd8b996aca9aed812212d1368dfc10b1371bebb96bcb7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59076c8c50ef1d7f7553808eb8025796d2f9812ed61040edc838d42d9c8eb4b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ada01aa090ca7fc6d427950f619e5c04b9a4d83715070e905e6fd443ab2b3a0"
    sha256 cellar: :any_skip_relocation, ventura:        "9515ec6c5683ecaad6475aac4e033f03217d0fdcad4776fc21ff9a72eee03cd0"
    sha256 cellar: :any_skip_relocation, monterey:       "6d64a18efa3cd81ae6c5ddea249dfd4ec0bb583716a3abb9f748d98880cb34c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b56eab1bc1428cc16045a6110c25cff091017acf228805ae10641228cf052535"
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