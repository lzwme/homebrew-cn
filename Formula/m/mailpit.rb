class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://ghfast.top/https://github.com/axllent/mailpit/archive/refs/tags/v1.31.3.tar.gz"
  sha256 "51aecda92a1805f5344c30bc079f23562ae659d7f58230dbd1f2b9274414198e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c678dd621989a949fe5d45a35336353decde11d75a75bed46d3e7a4049a77306"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9020ecfc6f014c27c016878789fef195093ebec6f78973e40f0d742d614f3ace"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a5083c6c2651f22e7ac506a72261a787b31fe1079c776f4e540ede0da0f3db32"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "13a48782ea02c8e7456937d634d100325968be910e8b0d70e2cff340d4a53b81"
    sha256 cellar: :any,                 x86_64_linux:      "b2295678c1ed073f221e04b8a31b47e5c27c3102a559f51b2b3220518c84d538"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  # `mailpit version` in the `test do` block checks GitHub for updates
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
    system "npm", "install", *std_npm_args(prefix: false)
  end

  def install
    system "npm", "--offline", "run", "build"

    ldflags = "-X github.com/axllent/mailpit/config.Version=v#{version}"
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
    test_email = "wrong format message"

    output = pipe_output("#{bin}/mailpit sendmail 2>&1", test_email, 11)
    assert_match "error parsing message body: malformed header line", output

    assert_match "mailpit v#{version}", shell_output("#{bin}/mailpit version")
  end
end