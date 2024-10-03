class Oauth2Proxy < Formula
  desc "Reverse proxy for authenticating users via OAuth 2 providers"
  homepage "https:oauth2-proxy.github.iooauth2-proxy"
  url "https:github.comoauth2-proxyoauth2-proxyarchiverefstagsv7.7.0.tar.gz"
  sha256 "c39ef56e482361dc23e64f52fa95cc5634326c46386f456828bbc6c2577172df"
  license "MIT"
  head "https:github.comoauth2-proxyoauth2-proxy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c121b4b020a78e72939b27dc9123a8960940a1cdbffffaed98ef05dc1af6e48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c121b4b020a78e72939b27dc9123a8960940a1cdbffffaed98ef05dc1af6e48"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7c121b4b020a78e72939b27dc9123a8960940a1cdbffffaed98ef05dc1af6e48"
    sha256 cellar: :any_skip_relocation, sonoma:        "23de60853270b531eb8a94c2c5d1125ac51517028755325c26a040a9242c4cad"
    sha256 cellar: :any_skip_relocation, ventura:       "23de60853270b531eb8a94c2c5d1125ac51517028755325c26a040a9242c4cad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e462c669c0235e34ff33dacbc356a50b4fc7dc97e64a61ae904bf16251193f77"
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