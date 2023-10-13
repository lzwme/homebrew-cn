class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://ghproxy.com/https://github.com/k1LoW/tbls/archive/refs/tags/v1.70.1.tar.gz"
  sha256 "f845ecb49b943cfd2ff27bb362420a9e3cd523bcdfe66e4e5c1ccec5b672c982"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8067a239f3b1b8da48c28cd2ecae67e2ce30c02eda43ba7a3059abc0c12e7b04"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6b67cc6cbd7b5d76e11865c82c76693c1d1ab36784f2b849f5c0cd7db3c135c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcfbfc8a165f961b5a8a33981cba31cea89373c4a0ccb0e4657dac0a72b52ee8"
    sha256 cellar: :any_skip_relocation, sonoma:         "48179ded8409bf546588563c518014b96baabcb2fcfdfc108250673bc44c1764"
    sha256 cellar: :any_skip_relocation, ventura:        "c9ac1e058280c4ac21d4f9cf29fd19164e8f926adec91cea4bc4b7c7816e7c6c"
    sha256 cellar: :any_skip_relocation, monterey:       "be4aba4bb6cd5b1eda0a130bf35c1c0212e23068cb75d9f9a4ff9252aeb024bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0889f55264390201dc26c62153f9d88480642de031353ae4d48ec5ff52ba8bf"
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