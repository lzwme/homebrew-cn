class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv21.17.1.tar.gz"
  sha256 "84fe7a766a798af86b797e5f2e914531e01e0bf7c8a712b7c4548ebd7986c6e1"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c848a57b9671a92928e3ec18f188b22e53782b1a2ddce6ab89a8a52809317f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e62e6fcdeed5b8797ab391920cab6c711ae8bf50ff3ee48a26591e476415701"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f26fd03dd48ccbad64db18116ded1a7513b1cc1a9020610ccfecfb71ddfac90"
    sha256 cellar: :any_skip_relocation, sonoma:         "a500cb6429b51efcf95141461b2559e12b02e2b3d60d98e1952347d5851a7a10"
    sha256 cellar: :any_skip_relocation, ventura:        "4e390946a166dd0db96d01f9e8432d13378845706100e8ce38542567ae9130bc"
    sha256 cellar: :any_skip_relocation, monterey:       "d88376b828a0091b215fe3cf6a53472e925d104b5aed2839b3fb3241283a6138"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "342b0399c9cd48e75680840671954cb7892d36815f01b3a1eeb16bd560c21cc0"
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