class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v18.8.0.tar.gz"
  sha256 "812222074e2e4d88eb2ff1609e21304ba687798aff3ed0981f9429ec314ed576"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf3e2a90c3fbe6f83c4af6737f4b97ad2607ffd8afa7f9ea3f58a669cba03447"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "609a77c5e6e04344be48da4a420133ea6fa603a4812e061a6c58fde67a1dd65b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "825469a3285dfcbf149faf3f8d7067282be5c141f4b190538730865753a6d481"
    sha256 cellar: :any_skip_relocation, ventura:        "aa96e18cd2dd020450ae52444edbd4eba6cada279455c763da97ca1c0ebdecda"
    sha256 cellar: :any_skip_relocation, monterey:       "f05fd3c8df3e2bfa5de69b2c44fd103e85e5415bc5bb08b4d26610c351a7a00e"
    sha256 cellar: :any_skip_relocation, big_sur:        "48b1e560a9f7f4d499f7cc2a2d1243ce5b84e7b734d03da239124ee8b4c804ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8190eba204501d7be8b0b3a99ce9770f58b5974a7a0eea7fb49624a03e1315b0"
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