class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv21.16.0.tar.gz"
  sha256 "0df8c51823ae55bfdb36b9f7fe44c893a31cb55f2ff12cab0106063639807d67"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "637b0abf07076ee9a7a706d4ce927a5dea70df58c1ae488491d62140097272f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1102baebfb35dbca041d2a06825cefdee8f67359948a0a8e8814b51c77456def"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1fc315043937d7b06fba3a3699167f8272327af14317ddd2e5fe14ed5c51fee"
    sha256 cellar: :any_skip_relocation, sonoma:         "53afdab2b2e7853eeccd38c9b248d65ccb48a56bde4cdfde90978f612c1b6438"
    sha256 cellar: :any_skip_relocation, ventura:        "9986c925a7f13ef646ffc4d4313e743ac85dfe1a56b5e53438e1dd80e73d5de6"
    sha256 cellar: :any_skip_relocation, monterey:       "aafe904f19fd6bf6481d8ac082f920bdac1cdddccef461b079a08facc8b6ef50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "879d6ff061fc1c9cd28e1d9842e934dbb3356da62224b22df943f513c3e29a44"
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