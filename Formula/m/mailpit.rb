class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://ghfast.top/https://github.com/axllent/mailpit/archive/refs/tags/v1.27.3.tar.gz"
  sha256 "c1085d01c97f1a12e0fdd1b19e8b7a1003ec4d2098d5ad16762fad61c16cafbd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03e918986c8d60cf1ba09329559ff538f3bb80e6ae9dca6c3496cd834ff3bfd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3042856cf7847cf6922ed644fa4b085184c51be07bd66023d533da9027c9505"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7df01b392027aaf6b683e979ebe7f00588e520dcdb2ef90c0bd66c789182fedd"
    sha256 cellar: :any_skip_relocation, sonoma:        "00bc1c3e8692453e9462e73bb2fdb6cfbaabd8e68667ed9169df1f6fb777c292"
    sha256 cellar: :any_skip_relocation, ventura:       "8ac5cfb5d7c5953dbf677d19ff98fd6bb1c3775fa0452442b950988557daf09d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad519c06339653edb04a88dc2925d014f3bff45b27947334777703859ff252e4"
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