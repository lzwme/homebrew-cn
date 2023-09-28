require "language/node"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://github.com/axllent/mailpit"
  url "https://ghproxy.com/https://github.com/axllent/mailpit/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "41314b783a776aa88cf03b685933f68a19368b3327c4bbd894cbc3546bf16523"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "98351284a48bced16fcdb0c2525ab3a37b4710025c0aeb27ea9d4f4536208910"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7cd2947560671605c824cd2cf9d8666cab8796142436f75a399d3261b097ee3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9d52ba837826f132e9c099b92b0b5674ae1ff0f5ea9f7bd71981bcc679fb040"
    sha256 cellar: :any_skip_relocation, sonoma:         "eee266424980bd382d7fbabd30b077679202094f3f10d7d3ab10a6ce7e4fedb5"
    sha256 cellar: :any_skip_relocation, ventura:        "3bc9d8cd04bc054ec27e5ebd2f90f3f1f76eef3e74d786d425936eb4aa54c758"
    sha256 cellar: :any_skip_relocation, monterey:       "bbc3e1cd3d332befa605aff922c83c57fd334917fdc29348595f3e26b157cef9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87e16f3861dca1bb784a982564d71378a5840df1a2c2e80715f6bc0c99cd5334"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "install", *Language::Node.local_npm_install_args
    system "npm", "run", "build"
    ldflags = "-s -w -X github.com/axllent/mailpit/config.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
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

    assert_match version.to_s, shell_output("#{bin}/mailpit version")
  end
end