class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://pressly.github.io/goose/"
  url "https://ghproxy.com/https://github.com/pressly/goose/archive/v3.13.4.tar.gz"
  sha256 "b2f19eb4026b1a8a20f57c27ea22715b7721efb4c6a93e2d6a89e4393705d1a9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf1a58b3c6441189064a8f47d7c22b1a11076a6c5e6d3c5beaa620ce792833f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d00ecda4459e64d4e7c90b262a4fa5f5d3cda5c2ad483ccdaed972d6d858085f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1101c1b98b64c84dd91d8622f9967afe536fa4053290a335e40c9e13495579cf"
    sha256 cellar: :any_skip_relocation, ventura:        "abb9590cdffa5f2f35d268c5689d36d8f408d14ac08a910683a5989382b7c606"
    sha256 cellar: :any_skip_relocation, monterey:       "bb818f60c420f6058608d41b6b7faac2fef3c4954f736cd5d1b606e9202e8c24"
    sha256 cellar: :any_skip_relocation, big_sur:        "61a2c2280afb94206223de626bac65137a43205e86800c4245602448f89f0631"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4db9a836e66d49be328937c4decb8da8a2a31dc8cc09b9239a76d4d71046fbe4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-s -w -X main.version=#{version}]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/goose"
  end

  test do
    output = shell_output("#{bin}/goose sqlite3 foo.db status create 2>&1", 1)
    assert_match "goose run: failed to collect migrations", output

    assert_match version.to_s, shell_output("#{bin}/goose --version")
  end
end