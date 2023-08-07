require "language/node"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://github.com/axllent/mailpit"
  url "https://ghproxy.com/https://github.com/axllent/mailpit/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "75fa4c80232aa594e25f9b5513fb2d5aa5e5c1ab55ee2198cfcb20559400d2a3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99e3ef8eb06f93fca1968b8d673ae00f3f0ddfdcef8dc96122bf22ccec83b2bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3acf84b8c28e1ad69e6b6cb014329ef7d01ad09688a17a76a02b7eb528d18359"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "049ee1748a6d5f071005929c13658183789b003b5f006e2999d5547a052c9218"
    sha256 cellar: :any_skip_relocation, ventura:        "f44ff30e90ac6177213c8daa071649c45d65a6a03156627001575f12442f0504"
    sha256 cellar: :any_skip_relocation, monterey:       "024272e927cb27039ddda5e09fdd21e2445082e0c9eedc78fbf9e73fbbf6e260"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ed8e6b4974e9425ee65c7e00e88099cc113ccd0a446d46e6926c2433e4dbbe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51ee15cff131ce9092a58c6536134667588d5f90f1bbee3a3c98d08a4adff117"
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