class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v27.5.0.tar.gz"
  sha256 "19cda1ac72d94268599efcf91552e2ab83ee23eb581763d5cd38fc96f837f6a3"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a811d0b13d228dfc41e2132a8cc877dc39f59e284209839a15fe5c0e781b3e91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "826795ab78268fd32ece2eaecc11624e0db3b0e5968012ed0fb44ea71008b5a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5738c970a04404cc8bc037a7b178a4a7c987e3ac02a48e5cf0667d55cf130f06"
    sha256 cellar: :any_skip_relocation, sonoma:        "c33c9fcaf11fd27b3ccac59d9e06ade85eca7680cc790a562da71958c151611e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8d786b1c40ea8cb520710812bc93ecaef53743611b06bea5abb7b43503806e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c487950cad8160b2f2490b9335fe883da9be7458403c9447f5ba04b7116fc9e5"
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