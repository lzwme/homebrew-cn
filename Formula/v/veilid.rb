class Veilid < Formula
  desc "Peer-to-peer network for easily sharing various kinds of data"
  homepage "https://veilid.com/"
  url "https://gitlab.com/veilid/veilid/-/archive/v0.4.5/veilid-v0.4.5.tar.bz2"
  sha256 "7914953e27b0e54eed5d30d05d258a3973d5be939542488f6f73d1df820c593d"
  license "MPL-2.0"
  head "https://gitlab.com/veilid/veilid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ed3ce133d4b6bc45be1d608721a73b96b170d79ead41cd26700257c8c16b761"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c735d77ddb08263e39382d800b18014b6ea505222ae67a7b339e23e1ab03c25"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "09f5f04c335851150480b38786b46dd002171eec314c18224c9d72778fdd6b0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "12bd3df8801c925b749606113bed9b2aac1d90e9ac537c60756c6809c928911a"
    sha256 cellar: :any_skip_relocation, ventura:       "bede4108c42453682d30dbdb6877d89033e0426eb46a33ce19e969090809b579"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ae0e3a3fb6c666418743119f4ec20e0193f89f23c8da275ff9a977a7159499c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05e8eba5c86c15189a62fbf2b015bda58a9d1d119052278ad8f4e8257a05cf88"
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