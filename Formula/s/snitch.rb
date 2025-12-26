class Snitch < Formula
  desc "Prettier way to inspect network connections"
  homepage "https://github.com/karol-broda/snitch"
  url "https://ghfast.top/https://github.com/karol-broda/snitch/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "0dca3cad9563e2bc76c0f23dc475d1707644971d51f52ed0a4cd317f30d05cb8"
  license "MIT"
  head "https://github.com/karol-broda/snitch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7cc122b706818cb174133f8355f38de919917153d82ac7037459d42c9e8f9c64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1835fe74370c99af892bfef4d24616526e4ab62eefc6a066f7a8082fd71d0f13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6b70ba73b0b4facd3f5d2684c5ed66fc25e5bc92e2118b018e3b3c2b693dbd5"
    sha256 cellar: :any_skip_relocation, sonoma:        "dac2cb026492da957b8169c9ec8cd0a1f33c8c8281509c3659b40298d6ed87ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9abf76dc60af7f39315e663bdf40dff130b82a5b985102718bee0e6da54b9c5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb9b532b581a84d2ce0a10b752832d47d898fb70895367879f416c2a9144405a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/karol-broda/snitch/cmd.Version=#{version}
      -X github.com/karol-broda/snitch/cmd.Date=#{time.iso8601}
      -X github.com/karol-broda/snitch/cmd.Commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"snitch", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snitch version")

    assert_match "TOTAL CONNECTIONS", shell_output("#{bin}/snitch stats")
  end
end