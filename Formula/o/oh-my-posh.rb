class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v26.18.0.tar.gz"
  sha256 "a3a587b98bfcea782b23f2c2791f83b60f78927ee47522d81ca92f767baa0bed"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a75ad908a66fb038cfa34736c00bf5230e1ff192eb33fe3873741948ff2fe825"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "679797aca62d44f20a27d221f0af8e5f2c1947866d8dd56f7e2dba275e5d68fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "94bb227b43c001d0ac24a9f65f7e4531b6e5410b91d1cbf39d1ca5f610d90b7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3dd61f81cadf4aa5254c3f6b8d7c56c6a3d8fde19b23486abd03952d12cee763"
    sha256 cellar: :any_skip_relocation, ventura:       "8ef1530850a9b9ce3c5a058ef3a217ecd7ce0637992efb66afc7a53b610e27fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffc0d56e9d83b3f3aa53a9404b1410a38e5d084109e0f3065f39dbc72d2a3e3a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]

    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
    output = shell_output("#{bin}/oh-my-posh init bash")
    assert_match(%r{.cache/oh-my-posh/init\.#{version}\.default\.\d+\.sh}, output)
  end
end