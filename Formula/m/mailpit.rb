class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://ghfast.top/https://github.com/axllent/mailpit/archive/refs/tags/v1.28.1.tar.gz"
  sha256 "74b3aaac5e759a2ad2b478d7b847f9dfdadad4d14390d1d33986714feefcd966"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2eca0d6a8973918a10172163baa709c50a4f1740b5d2c19120b743247232141d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0d8e5b858684930d5d0491109e35761cb85980d6489a10b475a12fa72530b1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b8f4dc395759833e5792679e315ebe5c238a1bb1c1aa76e21265f8412dd594d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b76c177b146c7c79dbba7b47060c5ca8b6ff2a395c64efe082569aa377ab2b02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36ccb6005856f2e858567bd718d18478b59bb198ec3535d61fa54fca0eea0287"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a87d3f89fae3845e67c8d504b2810fa95174083c38bd41790de820108c4e8f0"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build"

    ldflags = "-s -w -X github.com/axllent/mailpit/config.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mailpit", shell_parameter_format: :cobra)
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