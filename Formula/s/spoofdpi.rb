class Spoofdpi < Formula
  desc "Simple and fast anti-censorship tool written in Go"
  homepage "https:github.comxvzcSpoofDPI"
  url "https:github.comxvzcSpoofDPIarchiverefstags0.10.11.tar.gz"
  sha256 "4d907445a0c481c9b408907cb42757e90ab42c63cfcc146c96ec6eadea97ecba"
  license "Apache-2.0"
  head "https:github.comxvzcSpoofDPI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a57628628f08f100c9b6aff7895f1e351a22fc57230738db95e963738d38b855"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a57628628f08f100c9b6aff7895f1e351a22fc57230738db95e963738d38b855"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a57628628f08f100c9b6aff7895f1e351a22fc57230738db95e963738d38b855"
    sha256 cellar: :any_skip_relocation, sonoma:         "5263d4bf787acbb093faa0bfd0338bd0c7dd42104443d48c5302bc8533fb0434"
    sha256 cellar: :any_skip_relocation, ventura:        "5263d4bf787acbb093faa0bfd0338bd0c7dd42104443d48c5302bc8533fb0434"
    sha256 cellar: :any_skip_relocation, monterey:       "5263d4bf787acbb093faa0bfd0338bd0c7dd42104443d48c5302bc8533fb0434"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9a2bc123e67db561c66aa05de1e7572d653041d311cdb845b17cc53a530300c"
  end

  depends_on "go" => :build
  uses_from_macos "curl" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdspoof-dpi"
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