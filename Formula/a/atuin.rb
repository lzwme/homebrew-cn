class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://ghfast.top/https://github.com/atuinsh/atuin/releases/download/v18.24.3/source.tar.gz"
  sha256 "e132fedfe6ca8096f04a85887b93b029f2a2edbe1690bc713d02d9b8c846834d"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2560982b8bebc3b919e7fa543f7245a424e985d1cb4d23cc4a4ddcb2bb6f46bd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a313fadcc8d40a6666a765c504ce0a6146da8e9b48d9c9be6bee885878fcf0eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "de47e8f5f4924752a5436ffa69b2ac22da675241b4f72fb6447da8eb895adbf4"
    sha256 cellar: :any,                 arm64_linux:       "0b3a5017977e6300a8a9f22a30a58917591a0ac8e9cbc275025a029739c2be5c"
    sha256 cellar: :any,                 x86_64_linux:      "35cf5437f9381d44acbb63401e6e78210b69a91dc0aa9ed228ed46d60035bc70"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/atuin")

    generate_completions_from_executable(bin/"atuin", "gen-completion", "--shell",
                                                      shells: [:bash, :zsh, :fish, :pwsh])
  end

  service do
    run [opt_bin/"atuin", "daemon", "start"]
    keep_alive true
    log_path var/"log/atuin.log"
    error_log_path var/"log/atuin.log"
  end

  test do
    # or `atuin init zsh` to setup the `ATUIN_SESSION`
    ENV["ATUIN_SESSION"] = "random"
    assert_match "autoload -U add-zsh-hook", shell_output("#{bin}/atuin init zsh")
    assert shell_output("#{bin}/atuin history list").blank?
  end
end