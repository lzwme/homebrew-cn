class Garage < Formula
  desc "S3 object store so reliable you can run it outside datacenters"
  homepage "https://garagehq.deuxfleurs.fr/"
  url "https://git.deuxfleurs.fr/Deuxfleurs/garage/archive/v2.1.0.tar.gz"
  sha256 "63b2a0a513464136728bb50a91b40a5911fc25603f3c3e54fe030c01ea5a6084"
  license "AGPL-3.0-or-later"
  head "https://git.deuxfleurs.fr/Deuxfleurs/garage.git", branch: "main-v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3fe9cdfc6135cb389c27b86d862f83cb68543264af27b7ac5e68930c26d3c333"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ea2e5f244b5e882010eca9c928302deec305b3104692008da40e499e0633769"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0edd0db35051b652318dd4c7336a162de522634c0453bf5259462a3b4ddf7b58"
    sha256 cellar: :any_skip_relocation, sonoma:        "dae8779b0b79b263ec567c6502ecfe137724fd015f266181392947a4fd44379f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5a35bfcd3dc76012dcfa987d2f8b5b4540d79933c6d7ef5d3feca2c366223dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15bfa2bf012459491ccc1db5c6136581ed9c6322c1be2f6ee1c3febb4baa2a43"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "src/garage")
  end

  service do
    run [opt_bin/"garage", "server", "--config", etc/"garage/config.toml"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/garage.log"
    error_log_path var/"log/garage.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/garage --version")

    rpc_port = free_port
    api_port = free_port

    (testpath/"garage.toml").write <<~TOML
      data_dir = "#{testpath}/data"
      metadata_dir = "#{testpath}/metadata"

      replication_factor = 1

      rpc_bind_addr = "[::]:#{rpc_port}"
      rpc_public_addr = "127.0.0.1:#{rpc_port}"
      rpc_secret = "bb2763a7c7c397d17eb9d604c063699ab5de605cee438b7f4288e6ff1695081d"
      [s3_api]
      s3_region = "garage"
      api_bind_addr = "[::]:#{api_port}"
      root_domain = ".s3.garage.localhost"
    TOML

    fork do
      exec bin/"garage", "--config", testpath/"garage.toml", "server"
    end

    sleep 5

    assert_match "==== HEALTHY NODES ====", shell_output("#{bin}/garage -c #{testpath}/garage.toml status")
  end
end