require "language/node"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://github.com/axllent/mailpit"
  url "https://ghproxy.com/https://github.com/axllent/mailpit/archive/refs/tags/v1.9.7.tar.gz"
  sha256 "da597493cf7272c8181b68a9a29f67d813b62415183b7e51b4cdf880c8bcaacf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5e9e4f6087018deebabfb2f18b057901474b960f4a3de4f3f13f42c81eec4717"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d406b03c39d991fcc6db3f7faad83a9ce1870e4dee4d2d598f95f19ef68b3e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f54b4c17e3764df1464944f31822a03c131fa483ce6b2afcad4840fc9891c6c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "c68d295f4b1bf42dea2a36d404ccffa29dbd5dad6f08cefb12d091038dd50bf9"
    sha256 cellar: :any_skip_relocation, ventura:        "b903fe35772bc46359ea139507917c462556f606f43bf28dd82e4909a97f2c13"
    sha256 cellar: :any_skip_relocation, monterey:       "ccdd5cee2531cecff0dcc3f8bcbd3bd6ea52fe58b5d5757d6448ca33df626c1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f48cd68e455a790231b677ab25a2a65f0d83b511d08b00a34e15f23e5f9603a"
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