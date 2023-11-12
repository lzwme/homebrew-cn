require "language/node"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://github.com/axllent/mailpit"
  url "https://ghproxy.com/https://github.com/axllent/mailpit/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "4c44f0af8e008e968b94029a67fca7c7c79fadb7c50296191854c6302f2dcc8e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c51b84008dcc96094c0425a30f3453f1751369bab4e17ce3ea5b9ef1df0f0eee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d1f7d264adc85e686dfefb821aa80685da0afd552f13f295a04f8329d98fb4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0953646c45fdca11b4434564872ab65f1e5c2be874485990c1e9fe5be6c3457"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e41702b52554155bd58d09fe996113289129b5211d095d2c985c51428c2ceb7"
    sha256 cellar: :any_skip_relocation, ventura:        "8225dfd5d9892dccb3a2cf4e93d9bdac4634fb50b72970df5bf2ed54fab1bce0"
    sha256 cellar: :any_skip_relocation, monterey:       "1152a5b8a4ed898da86ed559b309e8b74e48a50b61d1bfe9d8e92f1b81cf6438"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccc6acdc2ad16b8ebb60f8d411ca2efe75516ce90d769e59b6dcb8bd9e5c47e2"
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