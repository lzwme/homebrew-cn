require "language/node"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://github.com/axllent/mailpit"
  url "https://ghproxy.com/https://github.com/axllent/mailpit/archive/refs/tags/v1.10.4.tar.gz"
  sha256 "a0f10d9667ce3130d23eda60cc5a70c6e8d978923fa7bb5d6449dd0ba95ff8ba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "29f982e9ad09f0466601b085c97da0b3289337410c53fe5e5a3b710c3cafd0c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1dc8a071bb79b03215e426101a1796ef5e9c50ffc128539bb8c1b5365c93f820"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8979de4dc96018b15eb9398dcb2245e6c2e8c0b9093f091f4df917bf987c6ce3"
    sha256 cellar: :any_skip_relocation, sonoma:         "645f0b030590d7bb8cda799d8a705d6368bcf5856cae7495faa5588ca358c14a"
    sha256 cellar: :any_skip_relocation, ventura:        "788ed330106137d72df715bf904f25987730f812b1f5ab37f61b2f854ba5ba95"
    sha256 cellar: :any_skip_relocation, monterey:       "644693cf41a238f8cfd63b18281fa802e2eb7221da742389f8886864690f7edf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6189cddd1a9e0f917e51efa2b5c3e1636bb9beee8e823a5cb988db689c155a5"
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