class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://ghfast.top/https://github.com/atuinsh/atuin/releases/download/v18.20.1/source.tar.gz"
  sha256 "c4faccd208fe3b407e83c6943b2d81081a94fe836da9b67f1a7b4d4f4bbb0fab"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71a1c66c832ad311c1b4cd1deb5fbe255503ccda675c5f3c670f60e51145548e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b857dbf4fe716f7e5664d434e1a8d2809939d1d85014610ab7be3429992bd6d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b5da9547442c2edff838b2fc2076cc11350e522dea3fb465e2944e211ae48e5"
    sha256 cellar: :any,                 arm64_linux:   "c8427c2bb00496870a15f39d08938907ae9f674f7e10c2612240bd70c9660246"
    sha256 cellar: :any,                 x86_64_linux:  "a88e6ec3b454b3d0156620867b2dbdd08bef3c06abf3f19067c4a3600c51e144"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
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