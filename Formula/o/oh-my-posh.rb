class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv25.11.1.tar.gz"
  sha256 "adecbd654c8c2d7b8303a098f4fcef3a1876babac65dd6d13c2036588237e486"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "579ef64a8eeed2aef34ae26baece221f4063a61bdb1493e9ed6263705205c76e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b79a096f982542a5b9bbdb8a10e7ed252ae801df53e08258e4b78a3b5a19ca1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe39f6910d1e05bcdb07c663ac38276fbe80ad41b4e057b76a63cc3edf86e6d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "61b93f6f42fa42ecdf2cc39752be99e46522b9d24db6cfcf463bbd94755d05f6"
    sha256 cellar: :any_skip_relocation, ventura:       "c4d4e1946738c82fea4ec4378d15cdf8fd6f496570b2c7e91a2efe981ae65a0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8640db75b43451385441f533b661e229d6ad7803aa6e68bb6571a3e0d468ad1"
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