class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v18.12.0.tar.gz"
  sha256 "46e0d45472df76fc7a7c8c66910de795072d622292467d9c0803b9a210cbaabc"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f86bd83ee6d393ca918bab6d0e62cfa35bcfb7b58616c3847274465c2eca9153"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a0b44cbc6861ae5e4467138443aa3977fd390606d93de77a16257d854907cbd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2cecef979cd21d15181053304849b2a9d32e8d66fea97c89045bc9f915257b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "8138f9560e598886d964403ed9e309f775946a1c5f0470b5d2862f9c8d598f87"
    sha256 cellar: :any_skip_relocation, ventura:        "a6e688ab4e7177ac16afb29d6cb72a1f32c2fe97f8266458af1382941cfeae1d"
    sha256 cellar: :any_skip_relocation, monterey:       "ab79cacc084b578c5f0ac70759f39d6f7f13d24b0b789d16f25c7c219c2d247d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dacbf59d6c12433fe2061a9f0996764c38409b703303e536af221bc48848af68"
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