class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv26.11.0.tar.gz"
  sha256 "cae4df0ef9a4530ec4625215d20fae74ba867ac6c81e6d1e04a6e89db2e4ac15"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cfebf6829e43824038edfb73a2c0e5637cd41a1639162928406d7956e9d2a16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a65236ad12302c75bf25e6324c3059c3e9db7cbda6b4d50b2c37d3872534b0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "65ee013a3db89e7b97a10e8b9924c48b9f681842c9924f729675a7317514da1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebfa12e88a33ad47f25d6dd24578ef5226318edfe602c27b4b7f157729d42fe4"
    sha256 cellar: :any_skip_relocation, ventura:       "f815ee5bc946df965503a91969abff4e1dbabd5f96530f1ac45856cce3a5a0d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83b8e5e8e23f76eca3f4beb82eff5f6578afa2e6de70f1f004c899cd6163dc0b"
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
    assert_match version.to_s, shell_output("#{bin}oh-my-posh version")
    output = shell_output("#{bin}oh-my-posh init bash")
    assert_match(%r{.cacheoh-my-poshinit\.#{version}\.default\.\d+\.sh}, output)
  end
end