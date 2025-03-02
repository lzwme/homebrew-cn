class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https:mailpit.axllent.org"
  url "https:github.comaxllentmailpitarchiverefstagsv1.23.0.tar.gz"
  sha256 "655ad5a18dc0bbc25ffd69ab23270e1f7ffbc623f4eb989e060c5c1de1ec07de"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9d683d5a528119007f8545a637103f0d6fe6b655ff17dce4b0a357366bb3821"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf4f9d2c6570380ca4c844a9b0e56951d5e14c3857958f3e6600b33116ca2c3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "269afc1a8fe700ccaacfdbef93253479c86ce0164d23216edec0a9c8288a280a"
    sha256 cellar: :any_skip_relocation, sonoma:        "34411b37e27760e43fd2271cf765b4fc38fc3fbc8eed0ee285b62bba554ae2ee"
    sha256 cellar: :any_skip_relocation, ventura:       "f7e8a9dfcd99dcea5efac9b60a240d043f957c88fc0e73fb13fc2f9aa8dac08f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "515f16645f3ae754769db235a0bc696e953dc05f26b8e75b497f76adcb1398c9"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build"

    ldflags = "-s -w -X github.comaxllentmailpitconfig.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"mailpit", "completion")
  end

  service do
    run opt_bin"mailpit"
    keep_alive true
    log_path var"logmailpit.log"
    error_log_path var"logmailpit.log"
  end

  test do
    (testpath"test_email.txt").write "wrong format message"

    output = shell_output("#{bin}mailpit sendmail < #{testpath}test_email.txt 2>&1", 11)
    assert_match "error parsing message body: malformed header line", output

    assert_match "mailpit v#{version}", shell_output("#{bin}mailpit version")
  end
end