class Spoofdpi < Formula
  desc "Simple and fast anti-censorship tool written in Go"
  homepage "https:github.comxvzcSpoofDPI"
  url "https:github.comxvzcSpoofDPIarchiverefstags0.10.12.tar.gz"
  sha256 "1ef78cc8afaf59216619cfd17b01dcfc554524fe2ee5a8365f239ba3eef63b70"
  license "Apache-2.0"
  head "https:github.comxvzcSpoofDPI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a5b171e4852205d9091fa34f7d526da8ee1810f78d5be4b49ce2ffad7484a2ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5b171e4852205d9091fa34f7d526da8ee1810f78d5be4b49ce2ffad7484a2ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5b171e4852205d9091fa34f7d526da8ee1810f78d5be4b49ce2ffad7484a2ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "38d8942292cd007b6b61b04006b308a4070162e33b566e9bdeacadd67abda435"
    sha256 cellar: :any_skip_relocation, ventura:        "38d8942292cd007b6b61b04006b308a4070162e33b566e9bdeacadd67abda435"
    sha256 cellar: :any_skip_relocation, monterey:       "38d8942292cd007b6b61b04006b308a4070162e33b566e9bdeacadd67abda435"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d69e49e0fdac02583937278a3be200683f5b6e4588db98e1766dc3a2bf07a4c"
  end

  depends_on "go" => :build
  uses_from_macos "curl" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdspoofdpi"
  end

  service do
    run opt_bin"spoofdpi"
    keep_alive successful_exit: false
    log_path var"logspoofdpioutput.log"
    error_log_path var"logspoofdpierror.log"
  end

  test do
    port = free_port

    pid = fork do
      system bin"spoofdpi", "-system-proxy=false", "-port", port
    end
    sleep 1

    begin
      # "nothing" is an invalid option, but curl will process it
      # only after it succeeds at establishing a connection,
      # then it will close it, due to the option, and return exit code 49.
      shell_output("curl -s --connect-timeout 1 --telnet-option nothing 'telnet:127.0.0.1:#{port}' > devnull", 49)
    ensure
      Process.kill("SIGTERM", pid)
    end
  end
end