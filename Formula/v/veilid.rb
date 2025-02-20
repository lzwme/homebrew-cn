class Veilid < Formula
  desc "Peer-to-peer network for easily sharing various kinds of data"
  homepage "https://veilid.com/"
  url "https://gitlab.com/veilid/veilid/-/archive/v0.4.2/veilid-v0.4.2.tar.bz2"
  sha256 "d5f29128e9160154b9d12e3b2ed3187b9c94bfcd24593eb9bb570351866b4c3a"
  license "MPL-2.0"
  head "https://gitlab.com/veilid/veilid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c046030d564e4758abcf41e47e30c0dabafe8a0cdab2dd8718e7e466b786119f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70a3dffdfeb1a8ed8417b27957f73ef87226e534d9b60c5d8a4db7ec435c9fb2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3a2fff9d5ba289bd4de747c7d4c66cab52f1f92ec3b09d89a2301f9b889c1369"
    sha256 cellar: :any_skip_relocation, sonoma:        "47b4d5a8c3433a7bc61a5a73de3ecc1802840e86106e0015b97858b61e308b5c"
    sha256 cellar: :any_skip_relocation, ventura:       "c0d8f33ed367c5e8842daa09556194f618a9e20b74605a4e4ef5a602b43d7031"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39940657abc13f80d9de0ea7e6f441dcf86b357b39c4dcbda46d713e1bebb154"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?
    ENV["RUSTFLAGS"] = "--cfg tokio_unstable"
    system "cargo", "install", *std_cargo_args(path: "veilid-cli")
    system "cargo", "install", *std_cargo_args(path: "veilid-server")
  end

  test do
    require "yaml"
    command = "#{bin}/veilid-server --set-config client_api.ipc_enabled=false --dump-config"
    server_config = YAML.load(shell_output(command))
    assert_match "server.crt", server_config["core"]["network"]["tls"]["certificate_path"]
    assert_match "Invalid server address", shell_output(bin/"veilid-cli --address FOO 2>&1", 1)
  end
end