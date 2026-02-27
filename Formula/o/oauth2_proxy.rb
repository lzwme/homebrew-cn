class Oauth2Proxy < Formula
  desc "Reverse proxy for authenticating users via OAuth 2 providers"
  homepage "https://oauth2-proxy.github.io/oauth2-proxy/"
  url "https://ghfast.top/https://github.com/oauth2-proxy/oauth2-proxy/archive/refs/tags/v7.14.3.tar.gz"
  sha256 "2e89d0aa778e55fbd92c66c9fdb91cdc960da9a7a4d0f0180418f733a925d5d8"
  license "MIT"
  head "https://github.com/oauth2-proxy/oauth2-proxy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be32323ca7079a7a03e82c27567cc8a5fa00e1d6a4c4d821c6d871b4976e6a06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0839d847c0686f841e473645f9adfa40cfd40056d628a7679f3283349754398"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c19593e499464661fa95d7360eb0bed0a821073569f219f1584aeb5f5ead4f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa5ba48973d0210aaf91db6ffaa97a19578b66f93cc876345015972a3bc78f12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebafc585d3e185a5141b4f07e0307913dcf1c1ccc289042ad04e6a8eace3bf71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcddfc3939dd47819f46075fb27b6d045946c047c9c276973213acaf428ced28"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=#{version}", output: bin/"oauth2-proxy")
    (etc/"oauth2-proxy").install "contrib/oauth2-proxy.cfg.example"
    bash_completion.install "contrib/oauth2-proxy_autocomplete.sh" => "oauth2-proxy"
  end

  def caveats
    "#{etc}/oauth2-proxy/oauth2-proxy.cfg must be filled in."
  end

  service do
    run [opt_bin/"oauth2-proxy", "--config=#{etc}/oauth2-proxy/oauth2-proxy.cfg"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
  end

  test do
    port = free_port
    pid = spawn "#{bin}/oauth2-proxy",
                "--client-id=testing",
                "--client-secret=testing",
                # Cookie secret must be 16, 24, or 32 bytes to create an AES cipher
                "--cookie-secret=0b425616d665d89fb6ee917b7122b5bf",
                "--http-address=127.0.0.1:#{port}",
                "--upstream=file:///tmp",
                "--email-domain=*"

    begin
      output = shell_output("curl --silent --retry 5 --retry-connrefused http://127.0.0.1:#{port}")
      assert_match "<title>Sign In</title>", output
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end