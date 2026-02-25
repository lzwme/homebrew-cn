class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://ghfast.top/https://github.com/axllent/mailpit/archive/refs/tags/v1.29.2.tar.gz"
  sha256 "8043cf644334c1a1b2f1a8458d40a53741ec1064425c47b1b78549a3cb411b84"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00441c44f786a0d09f1b584b532705fadc5116ec20ebd0b843009ee9cb3174c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19b28a15be9e581c9aa84b54152ea86f712bcbdbbbdaddc147f7ae89121c0c1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48133973afb1d8630ed8b6fb4e640546f646b508da43fabc8eeaaadd8e7e4d56"
    sha256 cellar: :any_skip_relocation, sonoma:        "064a379e2b8b56d578fece31369674f0ccbe60a8f015315dbfc4e368fe61cf3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9d99da7b9b3af0f74fa5c6093288c92fab3b7dcb7c05d92f064d68ed442628e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f419e3144cac23825fb3179969b87f4fda160387ca5e1232de837eaf6f3f9d73"
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