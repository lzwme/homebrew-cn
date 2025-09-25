class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v26.25.0.tar.gz"
  sha256 "73811b8e442abcb4444142fa31a999ca4342ba2dc91b498a3f34d1138a6d010c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33bd3970358c4fdce3a72f02ceda187c2a315ad8eb482f31b7a3efef456251ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc3719f835dc06c13abf41eead760e5fcd01b8bfe0c411c4a472e49ec3284709"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ca2913cedd49e72146bcd37871a59ca575f09d7fc73cac29942e001e984872c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9c6db6c0c7ce8236104ac35d1726c52e6030675e848f7f033dfdd393818152e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b726598c9e350d0692e50522ca1aa9997305a89c96540a69424034a4946cc88"
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