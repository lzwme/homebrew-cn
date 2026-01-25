class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://ghfast.top/https://github.com/axllent/mailpit/archive/refs/tags/v1.28.4.tar.gz"
  sha256 "626dc46198dd9d691f67f761fd6b8aac62b27e0e2b2e6453c278513f9f665478"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64fe3e34e663cf568fadf7feb683233f8517e09a57d09f08090500486cb229af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "940052f5f707d895e482c48ae38f8ccfd5737847606a66f16d38f52f60817ec6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3231d7f5876c7ec2242fa31bb268977ced72b1853cea0ac8e48d723a47b2392b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d27dc2cd87852939bd175a858221b21c28a806eb668c16e157b4030b476a4a45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f3a75d118c00469144e6437edc491494eb18dfdf3a7155073d083cafe380ee5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ece9d36b9fa51a31e02e962c4ddfbe69c6e778679e82ceaf9c27be4d7653288"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build"

    ldflags = "-s -w -X github.com/axllent/mailpit/config.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mailpit", shell_parameter_format: :cobra)
  end

  service do
    run opt_bin/"mailpit"
    keep_alive true
    log_path var/"log/mailpit.log"
    error_log_path var/"log/mailpit.log"
  end

  test do
    (testpath/"test_email.txt").write "wrong format message"

    output = shell_output("#{bin}/mailpit sendmail < #{testpath}/test_email.txt 2>&1", 11)
    assert_match "error parsing message body: malformed header line", output

    assert_match "mailpit v#{version}", shell_output("#{bin}/mailpit version")
  end
end