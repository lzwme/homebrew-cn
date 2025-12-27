class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://ghfast.top/https://github.com/axllent/mailpit/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "438581a2fd717d12b6259081420b10a8dab5af30b18b73c01db9cf5d83467869"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "531d6abbfd3e2c517ac42d9e641e9c3a89cd5bbeb89b8edf68c185821dd88a3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0309a75debc887ad0ce36019e6917e600853014f16e2a533f01926e71518687"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5472333659555406d985536b36b66f15cd7d48a3047003452b1fa348ea79a6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd8073b954c548c219e3e9e269fb7bb8e9bc870db1b2e16c8c39243e08626208"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70f06f87d278cdcd367edaa3f1fb3230ff82ef984357cb3ffe8b3c394ae6696e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9305b4ca046d2056a445e9e17c92a2c6f6052eacfa1d2349b58fb69d7c521cf5"
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