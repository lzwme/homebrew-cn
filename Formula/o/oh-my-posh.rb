class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v28.2.0.tar.gz"
  sha256 "f9011ff83cb28efd92adafd2d9010b8ec4605bece02975defff60c6f4591ef43"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8bffa02ecc60f0c72d8398d4818eca2cb894042271514f8808aa6a37cad34d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1195667f968f933a6e0ccf040e825cf732dae42470627c26cbd503c26aa1cfe2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3de1b89d7fa6e7ca13ae6cc58ab2eacbc33cadb31eac3a1b158f4db670bf5ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e9f9f92208244e9e39aa3769584527adeb2c2e1dd1a638258d6c072fccb421b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c6d3356e620530ed8838f957342ef4552bf2f8a8791766e45fb5972511f5ece"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26562f32f9f4418e366f3d5265dca23847641df098a116cb140805662a51b88c"
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