class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv21.2.0.tar.gz"
  sha256 "7a8b9e1aea460b58b9cb74aca37e2e5eb3dbc9ad7aa48b6279fe8b8d18e53a1b"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "01477ccdd73f8216c343879739f95d1e604351aaf51f085ec7c2009307932803"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b66965d7ccaf6fb815b45121718cb5fc1089589fa9f77fdefee650535f67d30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b99db13bfa2e0f0dd1c8b9faf123018588d76fe592d4dfa60c1ff18311ef543"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4e80f9ef84e79c354c0f4b87355cf19005fe0c225c06b64af782d6493a989aa"
    sha256 cellar: :any_skip_relocation, ventura:        "31637f923f88f3f1db39521404ad07a35c766abd55f242c6a055f9ebcf222ee9"
    sha256 cellar: :any_skip_relocation, monterey:       "8471252d04edbd031b2e54526d5d72adc932edf2be8fbbdbaf41fa78792c11bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d52e9695f196771df237fd552c04b31d30819c2cc26c838d67ba26ec3c2bb9fc"
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