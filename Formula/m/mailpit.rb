require "language/node"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://github.com/axllent/mailpit"
  url "https://ghproxy.com/https://github.com/axllent/mailpit/archive/refs/tags/v1.9.5.tar.gz"
  sha256 "f458f1061717a1a9e4ba8446b0275c2171677a646714d7b227bbed7eceb34bc4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d039ff8d0394d77c5cb8b14c1d81aaffb06268c92ea277f893b4fa06ba6938a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "edb6f63498f9dc846784f84361d836289b078d48cd259c4bdbc2d73a8e40d3f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7ecf6e39d30af74de510a20a560063ff82a8a867bee341238989aafe6d33d33"
    sha256 cellar: :any_skip_relocation, sonoma:         "d4e0a343701e0bebc6191bce393997a0075b1b489fd7bf259bc3b54dfc42fe5e"
    sha256 cellar: :any_skip_relocation, ventura:        "7e7dea871a1f9314085951503282a7a4a987f747c74102b7b6cd3bb1527ee48a"
    sha256 cellar: :any_skip_relocation, monterey:       "e6b17a7783a06698a9b6e2be4c9109dd7dcca1960ae6454319f8e2ee3ba1ee52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0920f491a02a9acf256d2cb04774cabb769842d9974042898705dfe6486006fd"
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