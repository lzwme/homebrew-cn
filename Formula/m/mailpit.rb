require "language/node"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://github.com/axllent/mailpit"
  url "https://ghproxy.com/https://github.com/axllent/mailpit/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "081d495305cc2a5e71db562cbfa0361ed8302a52c854eb89b0188f9eba7a6e7c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8a6c42cefd3cb73c218d1f423e98e099ec579cbe7e3afc2df89bfcf59d749594"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0feff5992afdb56ed7ac6b5e455f41b6dcdac80a8ab7c9c1914778b169988c31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1e28869bd1843407d995c839bd6911a1d8a6634d5d47e9f868be04784905709"
    sha256 cellar: :any_skip_relocation, sonoma:         "e84f776db2c2d9c8a18b4ddea698d2d483a9d6908afd0a27c93907c87e3148e9"
    sha256 cellar: :any_skip_relocation, ventura:        "0d7563a54ad4f1d93bf7513e136f4d6d03ab000174c824c6a50ff252e8078a2e"
    sha256 cellar: :any_skip_relocation, monterey:       "7904f096a92e8d11833c01933a2e33e4dd0e601cb925c6031180674328b78dfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d4695760f927fba8ef3b1a3f33cb4fb4b7bc453b7de4472b83ad22ddd47b3db"
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