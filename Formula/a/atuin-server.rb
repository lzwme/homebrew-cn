class AtuinServer < Formula
  desc "Sync server for atuin - Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh"
  url "https://ghfast.top/https://github.com/atuinsh/atuin/releases/download/v18.13.5/source.tar.gz"
  sha256 "a3d40446b43806461cd2e15d88cc0e6fe06cf6219de01db4db1c0f4de0150477"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07fac2a9627aa4d5964bab6cf5cea7ba1e9cfa63ca478c2df6b6b30665973d82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f4e224a663e0cd05870feab055a84a3f3d3a7f79bf0e3d03579b88afd7a0b20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f54ddd691a8ef963d0443f3f9b8ecc32dcd038503792871d13971425ffea8b9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6fa465597e78712be627599acebff4d3b8e329cb6a51ee38eef8c290916ccae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "865f3dd943be7db202af3f59d9f7a8ad3877cfc5578e964408a5b2c30c0b336c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a86f5ddca7429d434f65e2e5334eb52a33149ce3adb6363f1fce88126d49c03b"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/atuin-server")
    pkgetc.install "crates/atuin-server/server.toml"
  end

  service do
    run [opt_bin/"atuin-server", "start"]
    environment_variables ATUIN_CONFIG_DIR: etc/"atuin-server"
    keep_alive true
    log_path var/"log/atuin-server.log"
    error_log_path var/"log/atuin-server.log"
  end

  def caveats
    <<~EOS
      The configuration file is located at:
        #{pkgetc}/server.toml
    EOS
  end

  test do
    assert_match "Atuin sync server", shell_output("#{bin}/atuin-server 2>&1", 2)
  end
end