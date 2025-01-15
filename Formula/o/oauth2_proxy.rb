class Oauth2Proxy < Formula
  desc "Reverse proxy for authenticating users via OAuth 2 providers"
  homepage "https:oauth2-proxy.github.iooauth2-proxy"
  url "https:github.comoauth2-proxyoauth2-proxyarchiverefstagsv7.8.0.tar.gz"
  sha256 "022ab4e949cd541f9709d6cbca7f4fce6fa8123404bc9a2f8f73892a8609d734"
  license "MIT"
  head "https:github.comoauth2-proxyoauth2-proxy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e90b54ceb8474bca09883997e80af07b88805ac3731edf1c6f9e5790d993203"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e90b54ceb8474bca09883997e80af07b88805ac3731edf1c6f9e5790d993203"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e90b54ceb8474bca09883997e80af07b88805ac3731edf1c6f9e5790d993203"
    sha256 cellar: :any_skip_relocation, sonoma:        "03cbecaba67a8943b7d56b3adf5316efe946dfc05c7b454e2a3d3e23dab78a0d"
    sha256 cellar: :any_skip_relocation, ventura:       "03cbecaba67a8943b7d56b3adf5316efe946dfc05c7b454e2a3d3e23dab78a0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1caeaadd21751a1ed827f0c302667660a00f3c9a11908ff63f7bf71bc523d95"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=#{version}", output: bin"oauth2-proxy")
    (etc"oauth2-proxy").install "contriboauth2-proxy.cfg.example"
    bash_completion.install "contriboauth2-proxy_autocomplete.sh" => "oauth2-proxy"
  end

  def caveats
    <<~EOS
      #{etc}oauth2-proxyoauth2-proxy.cfg must be filled in.
    EOS
  end

  service do
    run [opt_bin"oauth2-proxy", "--config=#{etc}oauth2-proxyoauth2-proxy.cfg"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
  end

  test do
    require "timeout"

    port = free_port

    pid = fork do
      exec "#{bin}oauth2-proxy",
        "--client-id=testing",
        "--client-secret=testing",
        # Cookie secret must be 16, 24, or 32 bytes to create an AES cipher
        "--cookie-secret=0b425616d665d89fb6ee917b7122b5bf",
        "--http-address=127.0.0.1:#{port}",
        "--upstream=file:tmp",
        "--email-domain=*"
    end

    begin
      Timeout.timeout(10) do
        loop do
          Utils.popen_read "curl", "-s", "http:127.0.0.1:#{port}"
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