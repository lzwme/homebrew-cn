require "language/node"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://github.com/axllent/mailpit"
  url "https://ghproxy.com/https://github.com/axllent/mailpit/archive/refs/tags/v1.9.4.tar.gz"
  sha256 "5219be8f593bd95c8984e4efee68a65f09850fab991db72142106a84275df010"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b4ecd64dc2ecd58f0549f15aa8f86143dfa380f9cac42495c34d4ee7c9c5fca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0ff8aa2ba020340c943586a750b6d4042edce2edbeed13986f93660958ccd9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7d34ec13e0111ec160629c7a78f186024eb924359b189abec39ff0d97a805a3"
    sha256 cellar: :any_skip_relocation, sonoma:         "61225f79142d71a9003de22d1e4d46a95aea37c0e48713f373d9a8a6ded47283"
    sha256 cellar: :any_skip_relocation, ventura:        "217871279313a52c3c1b67fe6e5846255cc84d5bad7116d14a85de04c50adb23"
    sha256 cellar: :any_skip_relocation, monterey:       "7289e3ab1ef26b9db5485cbe063a49bb055950ba383e1f40907f62fc1c92adfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e36390c3eaf76a746150c206f4a2578144553786e60b53192e0f82ab7203c371"
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