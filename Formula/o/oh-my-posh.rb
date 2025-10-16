class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v27.2.1.tar.gz"
  sha256 "a8487eb3218ab25c5280232fa4e1b956fd3093e407e7b256e89610eacaea7878"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18df17504d63fa82c293e41eb1053b71eabb4f7f4b5ac7bb601eb9a80c722d27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5b2d7a0e3c41050f5ca3c6e17c4f0838a5e16c00d0acfbb8fb3aa0e613d9228"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "603ef5d4b00031124f732f7179042a98a4bc40afb2d69f3723bc3bfa07ee3529"
    sha256 cellar: :any_skip_relocation, sonoma:        "642d28e0984721daa15382113c3c71eafe40c39acd7d46ffbfc85b374e7d6f7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af2a07fc0d680e74467a6f2d1f820777ba6e339c1e10eab1ba9e043c131ed924"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea77017be221bc0f70ee83b7ffc4c225b8a783cdb725a2ea9a12c040576da6ba"
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