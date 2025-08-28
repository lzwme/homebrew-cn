class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://ghfast.top/https://github.com/axllent/mailpit/archive/refs/tags/v1.27.7.tar.gz"
  sha256 "f2824658a2190ced0aa8c1579ad32b9c8eed5573d3ecb251615b5db983d2f9bf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef0ceb8d93cdab34506ef791548aa9abeb5bd95e8b280de0ab295de43fd12667"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcc9cded4bb25978287b7be3fc28fec11dffd09b3692b624de468bd930fe3744"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d624db2b4e93d55842ffbdb54aa2098e2cd358649c72e6729876e630d6f461ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "768d08ee08049e7ebfbfd1a49baba1634964494fed1198aebec0c81a38ebf3a6"
    sha256 cellar: :any_skip_relocation, ventura:       "5ee36d811e0aa9c0505356aac7395bae0a8fcd0bb43779d786f0a017a0ff4250"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb9b750d281ec7972f636d5d7e63e261a7b100c111097e81a46291e683372f06"
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