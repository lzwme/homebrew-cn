class Dexidp < Formula
  desc "OpenID Connect Identity and OAuth 2.0 Provider"
  homepage "https://dexidp.io"
  url "https://ghfast.top/https://github.com/dexidp/dex/archive/refs/tags/v2.45.0.tar.gz"
  sha256 "69bed527e7821e4d11195a4ea035399ffb3c95764af3108edce5fff43ce20e36"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4964c18164ff3f375a91f84bf967e9ca92cef043bdac01617c4d6cf06ce6dfc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b511620e4ed6385ab4a6d0fe3e797c258daaae9da9f31512bf26dfb1cfffb909"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8f3bbc89f304109a11dc81595fe1ed8d1714380909bb4bee45045074b992958"
    sha256 cellar: :any_skip_relocation, sonoma:        "222f4bdcc84e6fd60be58ff93f81e451d991e91ddb0130bc91dc636abe736c14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2d2ab272845c14ce9e5d1e26bc6fd1f79a3ff5c977209ff43bf67a3eb70b0d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01681fd9e8a1e0a7a7549d6afedcaccee7943259964ecd284a6745bd08f9de5e"
  end

  depends_on "go" => :build

  conflicts_with "dex", because: "both install `dex` binaries"

  def install
    ldflags = "-w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"dex"), "./cmd/dex"
    pkgetc.install "config.yaml.dist" => "config.yaml"
  end

  service do
    run [opt_bin/"dex", "serve", etc/"dexidp/config.yaml"]
    keep_alive true
    error_log_path var/"log/dex.log"
    log_path var/"log/dex.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dex version")

    port = free_port
    cp pkgetc/"config.yaml", testpath
    inreplace "config.yaml", "5556", port.to_s

    pid = spawn bin/"dex", "serve", "config.yaml"
    sleep 3

    assert_match "Dex", shell_output("curl -s localhost:#{port}/dex")
  ensure
    Process.kill "TERM", pid
  end
end