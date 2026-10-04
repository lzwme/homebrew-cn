class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://ghfast.top/https://github.com/axllent/mailpit/archive/refs/tags/v1.31.4.tar.gz"
  sha256 "cd4d0d40044dde07df8ff5c168f6d95356770dca45627a9f9910ba66e70d7832"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "671becb8f25f581f8c0bd2abc0b9500fb5a824cda9164fa4641b35c4c8ee6eed"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9bf9a15c041071a5d9f0250d77668e826b2e9cf18b627c611ee4540fe3375af1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7748109843a7a22196e1643427e48b7974cc083e19275db6c2642327560a9c1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "aa8f756c559738c2de806e74632bcf0187a5128c4573664be07a32038a2765bd"
    sha256 cellar: :any,                 x86_64_linux:      "a948c670589cd3c656cb0ecb1c3a0a0653ea70679035a82381d775d7bc610c4e"
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