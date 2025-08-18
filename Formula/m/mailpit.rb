class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://ghfast.top/https://github.com/axllent/mailpit/archive/refs/tags/v1.27.5.tar.gz"
  sha256 "f5116a726f947e5229197cac1952b426ad4ca5d4f87661a9f055b4d0f016c647"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7433c10cdf980830b0ef16f99e05dbe3713530a7422487e7865831f4812368b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e26efa87a5d2cdf6f314eee8c5300bb6c1946a93c4c0c04a7a50009eb9cd1ae0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "adf9eef46e7e3fa209c38442b2d5df3de88ff3cbf8d31e2ed853756acd4c13de"
    sha256 cellar: :any_skip_relocation, sonoma:        "7349bf9f63fca52ab39c58f3b485054bdc5199980d98f1282ba1d2b61c8eb211"
    sha256 cellar: :any_skip_relocation, ventura:       "c238863d7b722db286d73d302538951588d25e2501ec5e5eb4013e6d6b0b9ef2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d87f7781a6b66a1905f33a8d454a943047ed89a095c64b3efcc047f55bc1a383"
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