class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://ghfast.top/https://github.com/axllent/mailpit/archive/refs/tags/v1.27.6.tar.gz"
  sha256 "07159abfe3e3f137c66bcf58e2e408b3c7b563a7b217e46b6f6cfa0098054f85"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0968db7088f176c46a2289b49a11f57cbaa86e55f9fe2c956b297d3b3d655e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1222c1ace051ef5161088a4e88433a429bb5fb09b78a543779404d803135eb93"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1475b84f9c8e423be915252da76b0071367a40c86dbeb0922f7e5d2bbfaa2490"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1337fb476c5be20f1f233ccddf39c934230d173a99569f445f73de3f225645b"
    sha256 cellar: :any_skip_relocation, ventura:       "48bc0c9887b8a9fa62942f659e8055b5aeb590a147febb71d938a026ee5e4653"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45c1b7c00583fc5104e446eba1e249a069555d8ec06031cb4c42df3e5f9b7f2a"
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