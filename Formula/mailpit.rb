require "language/node"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://github.com/axllent/mailpit"
  url "https://ghproxy.com/https://github.com/axllent/mailpit/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "61673f8e95a2987b9014005bc88cfc6025a3781b4cb9041061f01aaf714c9594"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef7e6e8063652503e959a4ab8974ec5689fd33a5fa93031d303420e43529af71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2c0dbd4db45c46f4aeaa4fe6005136d355b6478680232eb2ee353eb57551211"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c712d3ae2c51e62470062ff3f8cda0afbe10148351fb6a130bca751911a6bcb3"
    sha256 cellar: :any_skip_relocation, ventura:        "4e9bf9d1e3aeac1d613eb3bf026ecd1afc92d1e07e30c2fc852776f3f986df07"
    sha256 cellar: :any_skip_relocation, monterey:       "6baa82c8983202602241368f18e8a0f252ff96474ff4c99fd1864d9ed12b3d18"
    sha256 cellar: :any_skip_relocation, big_sur:        "c36cbed7bf6c7a6f5cd76644a484681f702f39420feda171a7db4342096b515a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48ea0302b02e56fa33aadb233d178d1b3b3a4f0d2ebddb3f1fb1065e3984d379"
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