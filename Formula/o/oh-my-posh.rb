class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv19.29.0.tar.gz"
  sha256 "e6fb856ac8a87125ed12dd8b83765a5c7e3e7ef225178f46d61ddbb3b6f55179"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d4c09262faf79e5b32d4fe0b30d5c35bf9964064f4a5d4337a6b351010c27911"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "323fa573ac4a82c0ccb70691d26b3af9fa72bf4286c86326fd45342eff23ab9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5a2b878b38182fb41eb5c7b412f5b121c45165e10bc5eba6aaffa3c92eb9835"
    sha256 cellar: :any_skip_relocation, sonoma:         "994348eca7efa387de0ac6efdb15fdae4d3f5eea6cb7879cd149cae336585f5b"
    sha256 cellar: :any_skip_relocation, ventura:        "09f6f784faca21eeff021110ccabb165cfb3207fda683a14421ea37e7bf63cae"
    sha256 cellar: :any_skip_relocation, monterey:       "5adf6c49dafec2b67bb79d8b8f85e3a89ef27886e6915e1a9ad7ca02941f2a02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac96db524016e2d7244aab88ac37f739145c4e5b85c811e8c6e265bcc6357807"
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