class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https:mailpit.axllent.org"
  url "https:github.comaxllentmailpitarchiverefstagsv1.21.0.tar.gz"
  sha256 "5c929d4d4a6648022df4e623d2e4c06928d6469a8b52503fd630434d5902fb80"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "528c0f7b8613eda4144a50051a86e7df6fb2f34fc3824d420516aeb3f0b3708a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "852ab6159ac8ebf41120ee07b48a5da1cc982bf0461c08fde7cadceaa5e9329d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "794d8ea9bc4c4431bb11bdcf73a1366e027fe4a1f7d8617c4972349256018c2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b0bdc1f42e92289a926123aca2be32395b602b57c1da56e5a9179cd5be17304"
    sha256 cellar: :any_skip_relocation, ventura:       "6769a6eb1d878b46a3b3c5941ed9e74d4b781090bbefba13c75c5a303ffb1c2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b924e6159062fc7a89ea8f86517c8568566a4f4ae1aed3be0d8fb72da1b922ce"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build"
    ldflags = "-s -w -X github.comaxllentmailpitconfig.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  service do
    run opt_bin"mailpit"
    keep_alive true
    log_path var"logmailpit.log"
    error_log_path var"logmailpit.log"
  end

  test do
    (testpath"test_email.txt").write "wrong format message"

    output = shell_output("#{bin}mailpit sendmail < #{testpath}test_email.txt 2>&1", 11)
    assert_match "error parsing message body: malformed header line", output

    assert_match "mailpit v#{version}", shell_output("#{bin}mailpit version")
  end
end