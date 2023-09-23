require "language/node"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://github.com/axllent/mailpit"
  url "https://ghproxy.com/https://github.com/axllent/mailpit/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "2e4c0db57431fc7a7d68bcae4fab78580554635526330083279d42b06f74f08f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9146ea1e72b311c649f668f1b4dc5b724a8117f8300be3b360907f44f3ae18c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1848955895802c719a20cfeca69cf333680a2d87906f18da08ebf0f8f01d904d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33ac59171c107ae5798c8098a82c7e7765f5b9dc9506f7bbda9808cd7069853d"
    sha256 cellar: :any_skip_relocation, ventura:        "76bb255b4222db8712c45b0725a7451fda6bb932d1c0fb3d0440aa14ab6c5912"
    sha256 cellar: :any_skip_relocation, monterey:       "7127e516bcbd4133ec84d697b227e4e5cbbcc7c042fe233a71d89a2875e57b07"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1b939eb658f0a23620a5e995a76e4bf1c23b6738b601f13664d69e7d63200f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16ecc545659fd3da8c418c6e54834878a18b3a0137ddae0d8204cfad0efb962c"
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