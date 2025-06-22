class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https:mailpit.axllent.org"
  url "https:github.comaxllentmailpitarchiverefstagsv1.26.2.tar.gz"
  sha256 "f23984397854044d3a95428859aa0a3ea1b4f995ef8b7b7062c74ddf135e549a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d5eae2f9b54003b98936b84712e24d3e726389e9531725ea22fb13d51ae7042"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9ad67131a4d763080fe0b708326a93ff5c88db558a7b07d37427412548c591f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1ad9d607f671ff267ef539bf7a620655bb0c0a379e027be80de5960a4dffa2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba690178263630f9539b80ceb31f54e8b032bff235f46418fe02ffbeaf279289"
    sha256 cellar: :any_skip_relocation, ventura:       "07ca10cdf7fa2cbd67bf1bb936564875de8534f7e002e94fee528bd82c36245b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0805faa15f648bb34a0b815c5f8474f6ae48fcbdee741b3896e6ed7664457a3c"
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