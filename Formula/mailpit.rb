require "language/node"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://github.com/axllent/mailpit"
  url "https://ghproxy.com/https://github.com/axllent/mailpit/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "fa4c9872c90bb6713432901b4c3e715bea7a41ac12890620b6c6ce9a36fd5630"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e402c429580e2bb4ba3b183e1899d83e3fee2256217ef2da13df096e623ece48"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdfcf35274f44dbc1fc87b03779342edd7b993d9744e95143276075fecb45a26"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4fb75b4c32a579caba2bdff0647a35d13546b2447fc0076926002c170ae885b4"
    sha256 cellar: :any_skip_relocation, ventura:        "15ee16a5e281d576f2d85e5af6423dd8d0a461c3cbea7a41b630edd7d19ecddc"
    sha256 cellar: :any_skip_relocation, monterey:       "54207db0c94f11f8f5fecdda4630c467f855e98dc1f2e734ff2c96573b8a167c"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d3cdccb69be7915c01e7f27200b24f1988b9ec6b98a91224d8229f993226680"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4770f1ca8d5cf4da94c0c723e29be5cec022c77cd521253347b6d005f78316bc"
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