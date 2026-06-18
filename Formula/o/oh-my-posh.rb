class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.17.0.tar.gz"
  sha256 "0ba10d815dc01cdde55f1e42abd0c0dde4f40141aa06ace9c651bb4a2ebe59f3"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "476c4734cbc3170f9cae19b2285fe2f0937d029885c1c967d92ffa8371f5a495"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7673360d9f6f7101f7850d94804549fd50d660f81ba87b0df64b2d1422ce216"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddb732435d6098270f7bbb0c174ccefcc073973c26c4585e06f94bb690657718"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1871262a13e4bbf37a5413cfc92b7a33994fe3f45dde36e57d3b007d23473f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c896098db5d988092b7e312aa2ed0e0e77a5fd651cdf0a965ebbbbd7ff5a7ee4"
    sha256 cellar: :any,                 x86_64_linux:  "e3d87f8dac5905170a8eb40ed8f02b26d45c9860ef13185866fd63326b26eb90"
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