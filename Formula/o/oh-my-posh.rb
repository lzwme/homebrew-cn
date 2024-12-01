class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv24.11.2.tar.gz"
  sha256 "22b1bfc7614a396e6acb7aa3ae60943f44e588fb9ede163e3fb18fc2a2125620"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04aed83869cda0b021d5e7228cb5f7e0c9d57da28b9c0757e54756fe4af1c999"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8c28c6796b1007d6a5b3f920aa2cf0a274ef11e65ae0862c992f767b32f8b12"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8daf55c144a28d0decb291302588d57543b32591cfe0750e3d93c6068316dda3"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fa6cd156c13694edf5c67d70bdc20cfc696a1284793420659a25ad9d3de38e6"
    sha256 cellar: :any_skip_relocation, ventura:       "ac18183f7a5d85cee4a781f4f6bf03a8a26a356480ee9b01f8d791cd09cdfbab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47c4bc6fa2a564d59b6c8b37e6e1ee4ccef63ecc93920b6aa3e7b16b6f2bcf1a"
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
    assert_match "Oh My Posh", shell_output("#{bin}oh-my-posh init bash")
    assert_match version.to_s, shell_output("#{bin}oh-my-posh version")
  end
end