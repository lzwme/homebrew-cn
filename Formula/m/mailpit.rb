class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://ghfast.top/https://github.com/axllent/mailpit/archive/refs/tags/v1.29.5.tar.gz"
  sha256 "4fbd01c8675edcbab7354ec564ecb537ebec0f74f28ce174f4652310b7505aa6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e365b1c3da6c23b88b204be7f07810b023aa2d71c6f7507e3aa38f106ac6f429"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "deef28418fc24c217ba70d80e6a7eaeafec4aefc49125bf33214ceb10a1ee003"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "078ef6f344fd861cf3936646cb93d57b09df926b05ffd842566c5bf8b60cf74e"
    sha256 cellar: :any_skip_relocation, sonoma:        "92735655f2ca34fc8792d1e32769aa75c38ecabedc65c57934a7771c261da4e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0dd8bac69d5cc8364d6dd2b6f74b80847296fce4f4b335fd1dbcdae5e4eed4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e3f6ce9ba95ae1dc042b21e8473e4e30219469d4a14799f835cd371f7ee44d7"
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

    assert_match "mailpit v#{version}", shell_output("#{bin}/mailpit version", 1)
  end
end