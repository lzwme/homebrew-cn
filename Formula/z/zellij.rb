class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://ghproxy.com/https://github.com/zellij-org/zellij/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "dee3c677eb4545d302895e1c0020f7da9aba8b154927c6ff215b59aec4fbec9f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "02a190b44759e254e978944ef574b14d8b626937d31458873702e9a02d89b0c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1678bb5537fbaa06f60912504116c7a60dcfa93b6561af002692ba4700d6b3bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c19cf46e7252eef1a094394cb76361514da1f2eae73a4f627b81894fdf39c24"
    sha256 cellar: :any_skip_relocation, sonoma:         "936f0c7fb1cf1966945829ce19d5dd84f404683375611244571533e08e7a7d4b"
    sha256 cellar: :any_skip_relocation, ventura:        "1d9470ad93f809fcee2fbce8fab79454cb7fc7a0526e00a045447472290773a3"
    sha256 cellar: :any_skip_relocation, monterey:       "2dd4b6a1fbac828ac4200875bc8f964c27b92c689432e3221822aabe17648993"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "779e8545c7494b2172b72c11030ca5c677319fba83ea47ed0d8567753d68254c"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"zellij", "setup", "--generate-completion")
  end

  test do
    assert_match("keybinds", shell_output("#{bin}/zellij setup --dump-config"))
    assert_match("zellij #{version}", shell_output("#{bin}/zellij --version"))
  end
end