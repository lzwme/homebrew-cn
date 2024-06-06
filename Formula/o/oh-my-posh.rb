class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv21.2.2.tar.gz"
  sha256 "9280b41d731f98efa2b589ae5c3cd67513691a6f4b6cc4a520148a856192597b"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6549d51694cacf75d67a46972385dacf2fe0975756c0253ab31cba75a5e85379"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb69671e264d6d6a6268048ca959cffc949361660f42b8ff65d572133a014c2b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e562b79c1773cf54dc088bd0b615afe34cd78b6e4bdca9c4f1efe9e7bd32401"
    sha256 cellar: :any_skip_relocation, sonoma:         "21c6c8a5fbb3269fc6586f293e515511b880031dce905f43466a099c88229f3d"
    sha256 cellar: :any_skip_relocation, ventura:        "f99a444b2821be1e257445c72128804ca5d085c58aa2c2ac7984b7d5b0e089a6"
    sha256 cellar: :any_skip_relocation, monterey:       "9bedc1b51058dffe3b9f40b495d9baa14eb67140079d36aa98162dbf880f90b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b571bbb9cfc580c3841330d916ed2eb5c64cabb37af8908ae4dec93d5f70ee6f"
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