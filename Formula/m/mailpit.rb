class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://ghfast.top/https://github.com/axllent/mailpit/archive/refs/tags/v1.27.2.tar.gz"
  sha256 "7cf1c39bdb2e0f3647186cf40d89c46bc43de662de5064a6bf41471432e6cba8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7364eca6d437b390012da0a67501d9e1e3d9321e6329dcd2047694fbda2c0ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "922e9eeca4cd843ccccae54920dbb37d9a8314a6bed427a291e4fe46d4e14a72"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "041660a7f81d1c8e72c6501b4af1ee8ae367eeefdca4af369f651d7d1568a757"
    sha256 cellar: :any_skip_relocation, sonoma:        "46bb70bdace6999a056448e18ab35d531652845be9e7719e9c7a4634aff24fe1"
    sha256 cellar: :any_skip_relocation, ventura:       "48efd68bce434d541bd8d4e08477f2a420c2c6fe8332375a99b791b609eac909"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90295f5d8d7208c5a4edaad9b7ae395a9f2d6242812ae17e184c2297bc645a21"
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