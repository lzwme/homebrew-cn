require "language/node"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://github.com/axllent/mailpit"
  url "https://ghproxy.com/https://github.com/axllent/mailpit/archive/refs/tags/v1.9.9.tar.gz"
  sha256 "b1e13c6bcf2e0225900312678dd62009bbcf9d5d0cddee0f341d30289f9f07de"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "14401d31225c7209837ac724ee4f1992134705f57ae0aae4ecf10b3981fdde88"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ea693f8b51154a94a79623b38a3ee0331ac0b080d5afea6198fb9f043e5ca30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e846d31df495de1e834098c9504831c9a9acf0f2abbb24fe65636d376366c781"
    sha256 cellar: :any_skip_relocation, sonoma:         "bc0d262bf46d4b6bea5af0bd4d5b86c73f1c51847b91770ed292ab67e27b757d"
    sha256 cellar: :any_skip_relocation, ventura:        "fd49df837df2cbb8ce7b8dff8bb5144ff8259b93363991788b12d8da329f0ccd"
    sha256 cellar: :any_skip_relocation, monterey:       "4d0566e0fa7b3094f3e6b1108e5a177864f1d8102e447a48605891a0612ab3f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f600c0f736b97b0aeeb037e98c18f1cb989f1ceb85336f1717ad5f739ebf645"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "install", *Language::Node.local_npm_install_args
    system "npm", "run", "build"
    ldflags = "-s -w -X github.com/axllent/mailpit/config.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
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

    assert_match version.to_s, shell_output("#{bin}/mailpit version")
  end
end