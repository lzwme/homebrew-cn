require "language/node"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://github.com/axllent/mailpit"
  url "https://ghproxy.com/https://github.com/axllent/mailpit/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "61673f8e95a2987b9014005bc88cfc6025a3781b4cb9041061f01aaf714c9594"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd22199d09e109f6f0340f57a2380bd34a2aedb0f76d6a910dca2f6895957cf3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ea373acdb24c8db063b293187af6aae9c80e85315828b735714dd9ac156c138"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7f3d56e4a6b3d6e1bb3e78b6e1a99031c3ea919ad44058dd2db4ab4013a2ff3"
    sha256 cellar: :any_skip_relocation, ventura:        "61f2e10990d755c93eb5f78e9c42534d3b915e8ccb928019ad4e09888c8d5985"
    sha256 cellar: :any_skip_relocation, monterey:       "df8823b74196c2a45c0c4eac199c067fb065866c0eec944855dfa596478e2e4a"
    sha256 cellar: :any_skip_relocation, big_sur:        "4910315fcf6a0384db5fce694c331ac255392f9176744799a677ecb577212aff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cc00cf78c293490018d0cb2eb15ae5a9e4b9c3a38c060bc2bef935559923181"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "install", *Language::Node.local_npm_install_args
    system "npm", "run", "build"
    ldflags = "-s -w -X github.com/axllent/mailpit/config.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    (testpath/"test_email.txt").write "wrong format message"

    output = shell_output("#{bin}/mailpit sendmail < #{testpath}/test_email.txt 2>&1", 11)
    assert_match "error parsing message body: malformed header line", output

    assert_match version.to_s, shell_output("#{bin}/mailpit version")
  end
end