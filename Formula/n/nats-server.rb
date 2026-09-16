class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://ghfast.top/https://github.com/nats-io/nats-server/archive/refs/tags/v2.14.7.tar.gz"
  sha256 "094114987c7f7d45347a77e1731a394d002115669b802b5475ef515d342358cc"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e9530b237c425a761943f4ef2812b96fa72adbda67b12917becbb2a15175ed20"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e9530b237c425a761943f4ef2812b96fa72adbda67b12917becbb2a15175ed20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e9530b237c425a761943f4ef2812b96fa72adbda67b12917becbb2a15175ed20"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7466b617dd757aa50cd5a55f0a28e49e47ca7f555129785da239e59d50f7c546"
    sha256 cellar: :any,                 x86_64_linux:      "a31b89bddf33c2a40127760880b33b93ae0eef98af5963162bf693742f67430d"
  end

  depends_on "go" => :build

  # `test do` block runs a local server
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
  end

  service do
    run opt_bin/"nats-server"
  end

  test do
    port = free_port
    http_port = free_port
    spawn bin/"nats-server",
          "--port=#{port}",
          "--http_port=#{http_port}",
          "--pid=#{testpath}/pid",
          "--log=#{testpath}/log"
    sleep 3

    assert_match version.to_s, shell_output("curl localhost:#{http_port}/varz")
    assert_path_exists testpath/"log"
  end
end