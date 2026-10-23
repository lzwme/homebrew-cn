class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://ghfast.top/https://github.com/axllent/mailpit/archive/refs/tags/v1.32.0.tar.gz"
  sha256 "239e28527f83a7e76765de1a23b4b0c5e49a782f4009ec9788af6703d25397fe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cfcb4e677b8bffedb9772d41176186caf008dc50521962079fbbc8421dad79b3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "70ba53bafbede9fd962456ccb9dc0dacf580b2eb38addbc1ffcbb111b240a2f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bcdcc96baf6da0c942f9a4c38d35960d46b7270bcd253a8e13ece3cc2b7c0f22"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1d5a087323894e82ba38fbbf5ea6fa9c584fce0381bb91d85206a6f79668967a"
    sha256 cellar: :any,                 x86_64_linux:      "c7eb9b56e8fb99b6c848646c265093a88d7c466f2fb6e0ca17c4ba1be8bcb8d3"
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