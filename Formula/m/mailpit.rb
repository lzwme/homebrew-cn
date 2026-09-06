class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://ghfast.top/https://github.com/axllent/mailpit/archive/refs/tags/v1.31.1.tar.gz"
  sha256 "23b822e23c4f89679bfa67e9952e557e9c2bd6175d670f914d16cb8babd35317"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8aafcbd34c72911a8c588b7743a63ba62cc063e3b4bb78ac1b406cb54679afba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7377b5a2ed9c0a6c375bbb3b865946eaec24a2c319b42a401392f7622d3ba66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82ee89e82bc6920d3b30a10695dd35fb1d8eab9bc4f64c140e6c1f10463b4494"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2209d24e87cca9d429f329c84dfef9cdbe0e3d3e85c98d516c107fb9262ab6e7"
    sha256 cellar: :any,                 x86_64_linux:  "dd27641931be95115d0883c805d3cec2084d7d27954c31dd4f1379e3edeef555"
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