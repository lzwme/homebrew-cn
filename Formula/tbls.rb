class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://ghproxy.com/https://github.com/k1LoW/tbls/archive/refs/tags/v1.65.2.tar.gz"
  sha256 "0c0bfc005830cacc0f09b730eaaad4abde75878c95be3d83573efd1d0411650d"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb06718de3bf61b9ccf8b330f64cf1387b6349d52eda80fa73a7c1a6cf4c212e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e079cf60dac0dc1409990412e63e2c85398f571849e583b0857274c408cb356b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb6339f738a0d8c6a93cff89362225290a414c35027ec97b57669ca37157d32b"
    sha256 cellar: :any_skip_relocation, ventura:        "54aa87bbd4f7b94a0c34fb9682db3f1032c3a30b649310f1c911d6d9d30c9bc2"
    sha256 cellar: :any_skip_relocation, monterey:       "64e67cbb9417c167b7229dcee6e2ed8ac5a03c0fd4a506dffda21555f94d617f"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac13e078a75889a6e59b818775df533739421e3b1863ae0ada9dc7aaee869bfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99cf1165d8a592e8b4d9048ebf2013ce482d6a6dc03a9f45cb75d7448ff035f6"
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