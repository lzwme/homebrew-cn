require "language/node"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://github.com/axllent/mailpit"
  url "https://ghproxy.com/https://github.com/axllent/mailpit/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "62a35d231716385bd562c8dbf49d46212cadec4e1ac861e7466d707e64342b1c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b94dc69a098bd9bf4f92be0eebc872b98b1ae5ca48183cea13fe6127ad608e6e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2eae6d8c6038c92d71afb6e1730eaeb25440ac004bf21ce7f8901c3e4d8e2663"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b22b7629e4e369eea987d67dd69874c64517241ca6d945f8a8918b30e58f28c"
    sha256 cellar: :any_skip_relocation, sonoma:         "bbc91e111554162ff574ff89db807f5f6a53e4b7c7a8eff7876f29840cc73f99"
    sha256 cellar: :any_skip_relocation, ventura:        "bb6d58849bbddf3802ff0389beb86b55a69d7c580107d62263e09b653438510e"
    sha256 cellar: :any_skip_relocation, monterey:       "dac99d8eeb5bbd0fcff4a1fad8cd9768dd2023f5bee7c07d36a5303ba2900069"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf999b91ecf8361c38e45f1666555233dd6545b6d4deb31b7a54fa3c4423e272"
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