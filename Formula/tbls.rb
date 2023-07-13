class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://ghproxy.com/https://github.com/k1LoW/tbls/archive/refs/tags/v1.68.1.tar.gz"
  sha256 "cbaacafa5b1d92e2715b877726b56db73690e30ce057a6a1f28e5b26aeaa6ce9"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61e3191a323c9b0ec05a86376190656fdff84246cf4a8bdc93430906898d9e5b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ca096606ead897bfeb88885c48c92334e57ec086233b9ff6cd677a798b3a4e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3388b6475e3dbff1b657882461f8ec83705a1acd8ee30d0a501d4e35ef8a2543"
    sha256 cellar: :any_skip_relocation, ventura:        "4eb79e71a304c540d63b9b325713ada326a3d68ddae8c6675b22f9e9b5f40967"
    sha256 cellar: :any_skip_relocation, monterey:       "8a4e670e1952f24342fa28e22c689f635feac906889dfe47d5551370c5e6ff8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b809e6ed315a077a4eca4abc917a254cbfa00f5f23400eaea39b9fc30aec987"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c17452687438dd53d5e40a9298924fd0a68c08116e739304d3fc587047894ad"
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