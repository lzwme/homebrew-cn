require "language/node"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://github.com/axllent/mailpit"
  url "https://ghproxy.com/https://github.com/axllent/mailpit/archive/refs/tags/v1.10.2.tar.gz"
  sha256 "93a3c875826e5f0e8952e21036d5bbd5d24ac828fb05e0a06226f2f02e0bb5a0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6366486fb77bced699bddc56d7f17a2ce849ec7ce31ef05171a4ed98f9b85190"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5fed52a2f661821c7b7f8c8befadfa95821ab93eb32bca4ca8e07226d3734b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f20cbe1130761678d7e5afe730a45d3b1c7c8357ef1432075ddf6a41144beb0e"
    sha256 cellar: :any_skip_relocation, sonoma:         "15ab1d5b161fd479a297ce400544c8d93269aff59839e964b6ae928f210ed6b0"
    sha256 cellar: :any_skip_relocation, ventura:        "da7bf19617ba037fc4d0a93026f5be7bcd9eb90db7db136c861cb65bdcbac527"
    sha256 cellar: :any_skip_relocation, monterey:       "1fa874fa124bf1f5b54e940eed2a11bf7a16223b9669dcd841296917f28a3347"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59aa9013c9bcf5c7c4e00599952e715c4ec0f5f5db01bc43441f8d39d17f3a87"
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