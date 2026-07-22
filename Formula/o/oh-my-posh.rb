class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.34.0.tar.gz"
  sha256 "73cc5b4ede3c40f5fe1191bdb6320973a8b2cb93632a69afbcfb26a864a03169"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9ac4e8bc6d7cc0296f38f45c3b0cb773761476b629b8f283e1a2fce790c7a90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f682dc33abee94afe56891b9f3e74f8ed3ce319bc8d00c9b8881c8de1208ebf5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c48585ed6eef033c2563f4aab9c32991d0c0ca53069d671a5993d13a05d8d21d"
    sha256 cellar: :any_skip_relocation, sonoma:        "99ada27190f309ff15f5aba775daa5d0e935db78234217674048c96ebefb974a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "150012af27d281df069f90ffbb19482fe12dd74c00780b55a41e3c3ebc257cae"
    sha256 cellar: :any,                 x86_64_linux:  "24a703527c0358f51563d5f978ec0131015b15b691600ad38f8e7a22a124612f"
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
    assert_match(%r{.cache/oh-my-posh/init\.\d+\.sh}, output)
  end
end