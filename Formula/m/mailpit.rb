class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://ghfast.top/https://github.com/axllent/mailpit/archive/refs/tags/v1.30.6.tar.gz"
  sha256 "0878c5880964e6130f9416063cd96f50ed4629f6737f364cf3bcc6dbd90d4671"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6a8aa7d6b9d5d0713c85eee83b9773e4347541703e2e60877dd6ccee1c06f94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07f7dc303fe1dfd964f944b71a33099f5354687aac7a3e1ae0522a9861801cf9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa3aed7f8a3a2cf4ffb8560a7fb5d6f2e88cbd42d155bd7404588e9acd40e38d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9bbabeca3ceafc0fb09664f42e156ab0ed65c9f5fe67623beb39999c0157e2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23e81a11cd12e9dc085ea88b9333a6519e99b6fc2cba73b621deaf9bfea8d96b"
    sha256 cellar: :any,                 x86_64_linux:  "8693edd157de250faf3c57fa838d11f917f47e9e03cc2efc330212e80b246979"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build"

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
    (testpath/"test_email.txt").write "wrong format message"

    output = shell_output("#{bin}/mailpit sendmail < #{testpath}/test_email.txt 2>&1", 11)
    assert_match "error parsing message body: malformed header line", output

    assert_match "mailpit v#{version}", shell_output("#{bin}/mailpit version")
  end
end