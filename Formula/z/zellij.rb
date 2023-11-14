class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://ghproxy.com/https://github.com/zellij-org/zellij/archive/refs/tags/v0.39.1.tar.gz"
  sha256 "4b2f00ea3aec0d36a8e764d33d521b09de936e3c94594536ccd348457e108e14"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3c08f9eaa31744b31271d1282443cf1af5e7fb1954f060f977f71647425bddc0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d53cc50854ef5ea84da1d31bd12bd9327bcabdb3e44c9554e7f8c5c8f4edd25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec35221785a2891ba3c5745f6d2a2741c75dccda0633152342c3a91592c8c406"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae56b2ffbf74f2e79893910bf0ae7b0aad04c711d5006b40ee86b78a18f0970f"
    sha256 cellar: :any_skip_relocation, ventura:        "7a3ba98a1c7fecf30d455097189f8248b2bdaf629ed5d8a12cbfb06a550535b1"
    sha256 cellar: :any_skip_relocation, monterey:       "119af9093a282e47700012c3f5c9bc1b62a043471778d06d953cf9fdc8b4376c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8646f85230f066e8f136d94f89dec726c032d3be73348af535f7c14e66a6ae5e"
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