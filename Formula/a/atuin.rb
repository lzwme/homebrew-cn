class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://ghfast.top/https://github.com/atuinsh/atuin/releases/download/v18.18.1/source.tar.gz"
  sha256 "ac3505b014a019ecb8657ba974c452b0068edf0c69962e3d677c4c49e9d7fe80"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8dd0ac6452b3b632556217b7748fd2485b07d9b086654c84788b5cc5b29b3833"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "833c80ef9b83d2c4427c0e55a8392439f72ce25661010d2c64a0ea4f8a78ff06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74ed8e1027d48662dae25f1b1ee488440d271bf79992ac28da4420cb3e66bf85"
    sha256 cellar: :any_skip_relocation, sonoma:        "98683dc1104bb0ee4c592a3d5946fd8baa8f48e1bb7ad3b4f80c601baca9d21a"
    sha256 cellar: :any,                 arm64_linux:   "08b4bdbf4d8ec21a6484f90cf4b238fc444571b9df4df0f27b38a6b7e72c1a1f"
    sha256 cellar: :any,                 x86_64_linux:  "80246f92990a2909e0c99161c2edab7c700d011fdb5514a4a1b99c18eaaabf64"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

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