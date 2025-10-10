class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://ghfast.top/https://github.com/axllent/mailpit/archive/refs/tags/v1.27.10.tar.gz"
  sha256 "08c63a2f43c8be0600e99eef258a29fac024cf545437039243a67705537af6eb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f68d7834eefacb6bbac943df6f6e5cbe34b52dd9a477ea6a2fb121b1b5ad4471"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72a6d8367cd30539bf84f4420f1f2d38d49f1214cbbf30727fe5b8bad668f4d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39ad747f01ead05fe899071a84db996e4ecb38291ebeef2ab8b64142ea04e28b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0255cca36d0337f81ed133a102e567085ae48e35121f2095f33dd904afce577f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "734eeefa4e47d680be55a80b1ab58399b17997ab5eb20c48e43067450ba5fc06"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build"

    ldflags = "-s -w -X github.com/axllent/mailpit/config.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mailpit", "completion")
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