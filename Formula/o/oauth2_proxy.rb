class Oauth2Proxy < Formula
  desc "Reverse proxy for authenticating users via OAuth 2 providers"
  homepage "https://oauth2-proxy.github.io/oauth2-proxy/"
  url "https://ghfast.top/https://github.com/oauth2-proxy/oauth2-proxy/archive/refs/tags/v7.10.0.tar.gz"
  sha256 "be485c9625e2e8946568433c808303e13b894ffa8bff79609fd0570f1ef7de69"
  license "MIT"
  head "https://github.com/oauth2-proxy/oauth2-proxy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f03be4b415f277d760449d807510ed721ba9a96d028b9ba01e1b5f05ae26969a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d176e4609c769c86a4fa9546972b3c395279e839e84df7b934361541c71c983"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "02a52ca22b9011fc00e0257f6202e2968472515d1951347fe70648144f8c71cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "c304bdee583994aa6899cae47a5aea3aac3687c944841440edad9b8365d8b9fd"
    sha256 cellar: :any_skip_relocation, ventura:       "d214c5a06f5154792ddf54f95ce04d5947c8bf1503a6fb4e968172c5ecc501ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5b62d94c1fc3da6c6a6d5318c89b5007254ae2cd254817f1ff9464c7d2f34c9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=#{version}", output: bin/"oauth2-proxy")
    (etc/"oauth2-proxy").install "contrib/oauth2-proxy.cfg.example"
    bash_completion.install "contrib/oauth2-proxy_autocomplete.sh" => "oauth2-proxy"
  end

  def caveats
    <<~EOS
      #{etc}/oauth2-proxy/oauth2-proxy.cfg must be filled in.
    EOS
  end

  service do
    run [opt_bin/"oauth2-proxy", "--config=#{etc}/oauth2-proxy/oauth2-proxy.cfg"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
  end

  test do
    require "timeout"

    port = free_port

    pid = fork do
      exec "#{bin}/oauth2-proxy",
        "--client-id=testing",
        "--client-secret=testing",
        # Cookie secret must be 16, 24, or 32 bytes to create an AES cipher
        "--cookie-secret=0b425616d665d89fb6ee917b7122b5bf",
        "--http-address=127.0.0.1:#{port}",
        "--upstream=file:///tmp",
        "--email-domain=*"
    end

    begin
      Timeout.timeout(10) do
        loop do
          Utils.popen_read "curl", "-s", "http://127.0.0.1:#{port}"
          break if $CHILD_STATUS.exitstatus.zero?

          sleep 1
        end
      end
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end