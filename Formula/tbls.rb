class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://ghproxy.com/https://github.com/k1LoW/tbls/archive/refs/tags/v1.67.1.tar.gz"
  sha256 "7485e200a3f8b09da463b393d1d20a6dd57f2abaca7ae117a44d451b8ac3e984"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a594417a0c5e25fa2db54b1315f548cdaa352c7d7e2204796ac56dafed077ebf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a664320baf7685b7b4b5bc40ecc4ef5f43b37d4f14ee722ad3aaf1b81eae36c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c83e3c6e3002e7f9737c7a7b99a7589eb3c7a3af5212483b840cb0567c83a0f"
    sha256 cellar: :any_skip_relocation, ventura:        "b98c96d891b1abc951b6f47d9ed5a0f3017b2da2614b648a57eed9183e4307d2"
    sha256 cellar: :any_skip_relocation, monterey:       "15121a89d64c339b75973b3ced3ea2b105d87e5cb930f386fc783bdb75c5c295"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3ad9a8243716dc3b40e68279e3c47d2b3c4b56a7b8372b6f04a9f0b922ec9ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0931180daf523d3e74460018969a9385f5cf0f63f31804e1edd35c04bc5b473d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/k1LoW/tbls.version=#{version}
      -X github.com/k1LoW/tbls.date=#{time.iso8601}
      -X github.com/k1LoW/tbls/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"tbls", "completion")
  end

  test do
    assert_match "invalid database scheme", shell_output(bin/"tbls doc", 1)
    assert_match version.to_s, shell_output(bin/"tbls version")
  end
end