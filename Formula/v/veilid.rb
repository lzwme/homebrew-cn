class Veilid < Formula
  desc "Peer-to-peer network for easily sharing various kinds of data"
  homepage "https://veilid.com/"
  url "https://gitlab.com/veilid/veilid/-/archive/v0.5.6/veilid-v0.5.6.tar.bz2"
  sha256 "899670742836d171750ddedc82a7d1f59f85b38ad5c861c8cec3de6c44a73659"
  license "MPL-2.0"
  head "https://gitlab.com/veilid/veilid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c50da05b12f5b54194cc917db6ce5d69a0ef21e4df42a52f7c78c20159974bf8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5925a95e6285f7f95c4327a03ebf5e8ac0f6e6380eabfa6725286778b161c1b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74c0b4e5e548000a483973c9b9a8d6d7e435018661afe3fd81b417fe6f40dfcb"
    sha256 cellar: :any_skip_relocation, sonoma:        "93840d21fb40a85a1f4da2f4a87efca320c49be0a644984ee7b4e4bf0c778ab1"
    sha256 cellar: :any,                 arm64_linux:   "bf2280be80f29cf0f8a4b8de7f7cf8adc1b3afb2a7259c609038b1c2e800af2a"
    sha256 cellar: :any,                 x86_64_linux:  "09bd19e3a642ee4b14958d6e0c9e411e554bd623057311589c36a3f2989a20d6"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?
    ENV.append_to_rustflags "--cfg tokio_unstable"
    system "cargo", "install", *std_cargo_args(path: "veilid-cli")
    system "cargo", "install", *std_cargo_args(path: "veilid-server")
  end

  test do
    require "yaml"
    command = "#{bin}/veilid-server --set-config client_api.ipc_enabled=false --dump-config"
    server_config = YAML.load(shell_output(command))
    assert_match "server.crt", server_config["core"]["network"]["tls"]["certificate_path"]
    assert_match "Invalid server address", shell_output("#{bin}/veilid-cli --address FOO 2>&1", 1)
  end
end