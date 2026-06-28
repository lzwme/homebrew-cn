class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://ghfast.top/https://github.com/axllent/mailpit/archive/refs/tags/v1.30.3.tar.gz"
  sha256 "1e6a94e92b5e6ebbdaed7ec2dd280b7d200185697d723044c5a9fc239fcdb6d8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b352905512c92445b4605893a457e845c00aa4bd67a6bc37244f9a80414a0dcb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d9594133b624a3f4a5696c3306d9eab54e233f5906cbf51ef0a0ec15329393e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9067136ce76515ca13af6ec416f7de22b0ebfde0dad16cc2eaebd555a0f69e9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "cff69f8acb045313e6b7e138cb058cae46f0937ca4ae2926ccbe45e12dcbff2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "592259b1453462fa3ffd51bccd5f7bec27e07cc03361772550d8f0e67846e16e"
    sha256 cellar: :any,                 x86_64_linux:  "de39785ea3256bf1e5f6c191f53f68e6ae68348044eda157de92c0f4f97b47c2"
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