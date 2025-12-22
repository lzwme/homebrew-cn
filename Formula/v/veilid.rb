class Veilid < Formula
  desc "Peer-to-peer network for easily sharing various kinds of data"
  homepage "https://veilid.com/"
  url "https://gitlab.com/veilid/veilid/-/archive/v0.5.0/veilid-v0.5.0.tar.bz2"
  sha256 "927b6186d939a75dab06cb3b4f5bf5ade63ac454f0ea9223c9966ddcb6fa3f23"
  license "MPL-2.0"
  head "https://gitlab.com/veilid/veilid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4332d01455c81ae4341a2f0f12c9ebdfa5fe2f74d16a95fdd2f1d0a49aa01e8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9be66255e6f97ae9f7dbe3ed9de6e0764aa2e1bfd9fa70ffb1a84749f1b8b9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cc17d3d89549b80df80df44e854920782b76077e4227f3db1603797713e7fc3"
    sha256 cellar: :any_skip_relocation, sonoma:        "82c5060ab345f88792605a0afbeb40a83d7a3b2484217a7e4687693661077fb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d4ac84d9fa3ec0859ee9fcc1a59e972bf261449cc8a25bd5c81d780d06d8bd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cd4d37c11f9f45f2c1fd82c275eea409380fbda745acd5c7a11fec01b9bb3da"
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