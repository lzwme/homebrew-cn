class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://ghfast.top/https://github.com/axllent/mailpit/archive/refs/tags/v1.27.4.tar.gz"
  sha256 "a7d168373ea2698cfa5dd5146a64ffafaf29c30f931ede9e917ac69369e645e2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ad53ffff8ae1917eed3a003c909c3a7baeb0127c2c09824410e4370e62054d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7318dcfa808cccd6b43ee7a2c2514fe35af758021f01ed5c9423f59e0f17ca61"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "13d9cb636df6160fb233995233ddeeef9eeb101d788bf0e7e451635cb7c1a100"
    sha256 cellar: :any_skip_relocation, sonoma:        "92de34f9cc6f7ebf1c8a1eb0af68326a39499d975823d4952ef09935c0d5ce4f"
    sha256 cellar: :any_skip_relocation, ventura:       "e0e8684f6ac788f5e6f63326cb341c57b0029e8a95729c3b5a8ca9a975b9f39e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b2d9a51d83f38653832684bc1300a6de6b5f0b43d5f3dffa3c55de29c719e99"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build"

    ldflags = "-s -w -X github.com/axllent/mailpit/config.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mailpit", "completion")
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