class Boring < Formula
  desc "Simple command-line SSH tunnel manager that just works"
  homepage "https://alebeck.github.io/boring/"
  url "https://ghfast.top/https://github.com/alebeck/boring/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "1cd88b307a6a3757a89ad3b488e27e514dd6edf3c3747331e55b1abd165a10b2"
  license "MIT"
  head "https://github.com/alebeck/boring.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0d7e6d13da3f8d5de70d2e2c715f991fbbc003d8aa9ba9f40c307afa19e29293"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0d7e6d13da3f8d5de70d2e2c715f991fbbc003d8aa9ba9f40c307afa19e29293"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0d7e6d13da3f8d5de70d2e2c715f991fbbc003d8aa9ba9f40c307afa19e29293"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c6b353feb8644a5e1ca7956cc72ddf1c0c385425ee6ab0f88f65a05c2584fb48"
    sha256 cellar: :any,                 x86_64_linux:      "ce7a3385d8ac4d808e125219ea57b85761339553b70fbc54c04b819dfc52d268"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/alebeck/boring/internal/buildinfo.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/boring"

    generate_completions_from_executable(bin/"boring", "--shell")
  end

  post_install_steps do
    terminate_process "boring", must_succeed: false
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/boring version")

    (testpath/(OS.linux? ? ".config/boring" : "")/".boring.toml").write <<~TOML
      [[tunnels]]
      name = "dev"
      local = "9000"
      remote = "localhost:9000"
      host = "dev-server"
    TOML

    # Keep the daemon socket inside testpath, the only place the test sandbox allows unix sockets
    ENV["BORING_SOCK"] = testpath/"boringd.sock"
    assert_match "dev   9000   ->  localhost:9000  dev-server", shell_output("#{bin}/boring list")
  end
end