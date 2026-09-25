class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/", browsed: "2026-09-05"
  url "https://ghfast.top/https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v9.6.0.tar.gz"
  sha256 "c3386da89449ca7f453b0f92572730d1f08dedc49fd02a5059ddd934321651ef"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6bac873c4680069d4ab290e8e07cf7b36bf765edab01afefc218ef8640cf2869"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ebdc6936c70bae93ecb55abbee0cc78aa2ce84c37d06c33e37a459a7ea57bf74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d476fb7b03302a9c113338634b7074402a4db2bddb2ecfa50563158ca91262e6"
    sha256 cellar: :any,                 arm64_linux:       "f881c6542f3e8f849e440d0f1e28a287d61971d93f754a06fc78834cd9e8095b"
    sha256 cellar: :any,                 x86_64_linux:      "db9b8e0c2d516476dcc6e5e006ece18f72b662addd61fef5213bbf02d93a5583"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "zip" => :build
    depends_on "elfutils"
    depends_on "openssl@3"
    depends_on "systemd"

    on_intel do
      depends_on "lld" => :build
    end
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Remove optimization to allow bottles to be run on our minimum supported CPUs
    inreplace ".cargo/config.toml", /,\s*"-C",\s*"target-cpu=x86-64-v3"/, ""

    system "cargo", "install", *std_cargo_args(path: "crates/aptos"), "--profile=cli"

    # stdout is not supported, so install manually
    %w[bash zsh fish powershell].each do |shell|
      system bin/"aptos", "config", "generate-shell-completions", "--shell", shell, "--output-file", "aptos.#{shell}"
    end
    bash_completion.install "aptos.bash" => "aptos"
    zsh_completion.install "aptos.zsh" => "_aptos"
    fish_completion.install "aptos.fish"
    pwsh_completion.install "aptos.powershell" => "_aptos.ps1"
  end

  test do
    assert_match(/output.pub/i, shell_output("#{bin}/aptos key generate --output-file output"))
  end
end