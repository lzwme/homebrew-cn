require "language/node"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://github.com/axllent/mailpit"
  url "https://ghproxy.com/https://github.com/axllent/mailpit/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "a600d9e6e4cf47ce711c6ec1f1f6b9785672e411f5e5a4e20daedc6d8e45ec5c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04ec274991ebd4e069ed91b0a3b88c6dadd58188b4e8847232844e0ee4b1295c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49322450961f19808e2e023ef6fe5091dad6ef19c361390bb0f121b04f6115d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0af0d2416efef2f4170c73e9a868897ef007d186714317d80cedbd1aac03e75"
    sha256 cellar: :any_skip_relocation, ventura:        "e6a8a95283d0591db2597a399024f275b57577eb269e5ead5c57b3e978c89606"
    sha256 cellar: :any_skip_relocation, monterey:       "e31c7116de1533090d3ea3c272e5183917744a8a3b19145e66fb1eb90c5f6f2d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c871dc1e38defa262dd1d8dae065f1f8935710281a259b495bc0bdf5804dc866"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50350d3e75e536bd83921101ea0bbc3364133cb844fbcc1d8fbce97e545e8195"
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