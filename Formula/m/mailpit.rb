class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https:mailpit.axllent.org"
  url "https:github.comaxllentmailpitarchiverefstagsv1.22.2.tar.gz"
  sha256 "bca5386a8112734c32f86b3ad7ec15be2fee4f0aca2ae9890b4226478702f536"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e704de404f040db7d9c97188ad9de5d7619965328c2098fd4fa69fe65c60dbbe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "817b5e25f6d249e346f60688c651b313880ccde45c35d37626f7cc9cd06cb240"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b7ece9bb4c14ac0bdbcfe8c34339f99cfa68c42f6b9f6cebf68cc7bf227f226"
    sha256 cellar: :any_skip_relocation, sonoma:        "4761d53fa374fbae8f4a0a781ba8cc5cf33d48b2ba2641144bdaaa7c49d1787a"
    sha256 cellar: :any_skip_relocation, ventura:       "38a97375803c6780b8d51f59ac465ffb48acea25c6101a1ea7b699bc5b446f69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81e5eb51b94a4586a684d5152c1ca1c8c4a06a0c47c494792c6c01825b463bf2"
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