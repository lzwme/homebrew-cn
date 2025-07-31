class Oauth2Proxy < Formula
  desc "Reverse proxy for authenticating users via OAuth 2 providers"
  homepage "https://oauth2-proxy.github.io/oauth2-proxy/"
  url "https://ghfast.top/https://github.com/oauth2-proxy/oauth2-proxy/archive/refs/tags/v7.11.0.tar.gz"
  sha256 "1c32bdf0b9650730cf5f22f02e6f1fc628cd6a25617a076dc9d551a65a29e9b0"
  license "MIT"
  head "https://github.com/oauth2-proxy/oauth2-proxy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "110b81f4879e94018fe919dbf3a4303122a2991f25d8c01bf51445181fd7f384"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c3af408caf875cc63465bcfcdcfa994c4187f2250cc7c832a6b9baf2b9a089f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a5f59b2221c5ff5ae259b79da69995cd66a17f4506908aa42c6e7a252fba077"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d7257d569e962bdc13b8259ba6761780e3fccc5bea7480a0c0dfb5ee00efd40"
    sha256 cellar: :any_skip_relocation, ventura:       "69d38e7a995bd04e9e4028cdf87354a58c25609dbb09d38fc3da8ef1a21a988d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90b2d54f6f65fc7e21f41930de9e98d1f78e4cd13bf83a59cecaf223abbc11e0"
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