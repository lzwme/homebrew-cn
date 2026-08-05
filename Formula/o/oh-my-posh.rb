class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v30.5.0.tar.gz"
  sha256 "b4a2df012745dd7277b1d01b1fb48676e3eff727469233cab863455c9e66ae5a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "464fca004eeb89a4e58f2511fdf04dd27102ad7edd8a493f8792dc7e9a8e495c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef6eab27e597ce0f597a0ae555357e44ceb5d8d1f8705f23c12601de1f19fb3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db82aa696b29c5a663a7f4b507a05cf0698473d5c375b96f20bb62247ddfb4fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "9dc6f26a86fdd283e0e670f3623997bc5a3a641bed5aa375ba0dd8385a901812"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee06dfa0cc6b8e5716d91ae6e3005229566851798b3fd8be9a355f2973589bf1"
    sha256 cellar: :any,                 x86_64_linux:  "701c1822060d670458e0e340851843673335a2d3a97abde14e74d7ec4f1be152"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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