class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.20.0.tar.gz"
  sha256 "262cb3a587ada6732ce8cddbfe0a19edee6481cd83dba5ee41c07b8d4efb740e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d376210edb1c8a65eac90caa4fcfb22ff7abf907bbf27394f173ef09284653ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54507985b8ac80315a725e922ee423b55e4937c8b18e3e9cf280b27c0b453db8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1336af90528b39651e8746bb449091a5fd2adf916b317215b64025c430fce8b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd95e6a55122b962c2fb5d005f398b0fba3d4222dd0e352e07e4a3c223ab7be0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a485ca1ad0323fe00416a4f6941036d5400ddb398e6ce52e8ba71139cf581389"
    sha256 cellar: :any,                 x86_64_linux:  "01a07dda363f688cf251409dc079dbe08a96bd8fc8a9590cbf1958603fdaacb8"
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