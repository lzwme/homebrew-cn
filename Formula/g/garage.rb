class Garage < Formula
  desc "S3 object store so reliable you can run it outside datacenters"
  homepage "https://garagehq.deuxfleurs.fr/"
  url "https://git.deuxfleurs.fr/Deuxfleurs/garage/archive/v2.4.0.tar.gz"
  sha256 "b18ce849d46491c9d8168351ab8479a4ed0b6ce9faaeccad6e9cae0a3c9674a9"
  license "AGPL-3.0-or-later"
  head "https://git.deuxfleurs.fr/Deuxfleurs/garage.git", branch: "main-v2"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88b6b02f40451c9d88f85b3e3b821773bdd0ac62ac381cf891e3b5551ba14dc6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a529ec66a1e2c6f452a1eb560e4c22e6fcf3d6c18ad2d0d8fe406f4b51d1a79d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a709c8e0b76aa56ee64318eb1edf5938f526c5ae1b5404bd35f8874c8616049d"
    sha256 cellar: :any,                 arm64_linux:   "90135325afcd9476395e810c8596040bdce4e3c546c849dbe72782155bdb4570"
    sha256 cellar: :any,                 x86_64_linux:  "cb816a9999dd1844d68287e423aab27c50243109e51480142927265c91229a48"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "src/garage")
  end

  service do
    run [opt_bin/"garage", "--config", etc/"garage/config.toml", "server"]
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

    spawn bin/"garage", "--config", testpath/"garage.toml", "server"
    sleep 5
    assert_match "==== HEALTHY NODES ====", shell_output("#{bin}/garage -c #{testpath}/garage.toml status")
  end
end