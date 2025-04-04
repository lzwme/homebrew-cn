class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv25.12.0.tar.gz"
  sha256 "6b9a38675ac231d8c016004d04ae76e79388181444680b9d73be7166fc51e7e6"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc128bd2c675155c6f4655c5b825ffaf268aedd00510be9657e264859f81b282"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "acd0a2d5a87419aa9e1084f53b217817fa5832898a4b2fee6acd1568ba5253bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "256b693fdf6c1d2c784d7a7b1964aae7c8beffba2a6f9d68209b07ea9deced3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "15a22e868e3350f03a69e825627db2a3b76e9e3dd4ebf522c29e09ddba71a02a"
    sha256 cellar: :any_skip_relocation, ventura:       "728eb37fbe8bc3b89a50793aaf222002bb527624d60730ab7c71df2fc2270ebd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "875d7a3c4ab7240f639bf67a5d9e6f78fc49e6895aa9430ae13c4fcb656d69b7"
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