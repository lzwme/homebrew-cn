class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://ghfast.top/https://github.com/atuinsh/atuin/releases/download/v18.23.0/source.tar.gz"
  sha256 "64b4b9b0f84ef34bcfa88e992d38cc0b95d3cf1f6d470bb695d3ef0231445b26"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "37019d5625e52010e7cce5cfa1c6dbfcdf1148a2b1bdd076efc771bc06030138"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "99ec9f0401ff11313253019ef0c0637245cf436ad7522b9a2a93050d719c59c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5ba84ed3cb5eb293b3b8d1c7bd41166e0ae955a7bef86b783227e03517edf5fa"
    sha256 cellar: :any,                 arm64_linux:       "460253ab261880268c9c88bc24e37fd00a743c5529e9817e3004fddb71881015"
    sha256 cellar: :any,                 x86_64_linux:      "74ee10928bac474c04474d28ab4d69bef614192d014703d687a5ec467338fb1b"
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