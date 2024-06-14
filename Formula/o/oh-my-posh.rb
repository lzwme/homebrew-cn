class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv21.7.0.tar.gz"
  sha256 "77e253b5ce28a323a420b1dc9e57b0ef646b898513c4c97235f22ac0593bfbd8"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1b45dc89fb643df285364eedc4cbbe647fbb470158b0bd795a5b12985b6c04ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14bec44007437df49c273b1776ff274e6bdb61e7316fcf9c025534e9d7a99bd6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63a4e601d0be500cfe110b3945286a20d331fac64a6d5e3622997bc490197d07"
    sha256 cellar: :any_skip_relocation, sonoma:         "336000c2ae3adb21f04755ad3fbb73a990c82614c92dfe61dc9bdfe8d9e7594c"
    sha256 cellar: :any_skip_relocation, ventura:        "fe95adac9f07bca5f776417089ff0212e8afb567b7b77cd1150980e3e4de3dd7"
    sha256 cellar: :any_skip_relocation, monterey:       "22a64eccec0acaa77919afaeeb56eb002dbab0f315c9dbc5b963a9cfcee80600"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e8a7eed0aa8e7c0e707c2e87d5619e27f899143dff983986b3f3da06595e58a"
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