class Tbls < Formula
  desc "CI-Friendly tool to document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://ghfast.top/https://github.com/k1LoW/tbls/archive/refs/tags/v1.90.0.tar.gz"
  sha256 "bf26da292fde3eb7dfda789964179e6cd678ddf11578a5146badc34e2aca15ef"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de744ca28d9aa9c76d5a6be2e8e8da024c9ab09a94baad2ea066974c55dcbe25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1c7bf4748a4e262314418a2cd06fdcdda69508b1460c3272ffd7c3e17bf12aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbfd58d1898fb59bc2a5c373c9ec72e3a1a5f711c6d252a30f7a1bcf43ce5e4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "63284761b8b1adbb86f2a8205e174b6b3e859fccd86b5f82be13e40f8c173220"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72f58fbe8c921d7df20bed1268a641b35879c715627f39134f2a124ccbe10672"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ed2521d83c22f4b786c555fb4537742ec08850aaa3e1371d52bbec9bc8971e8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/k1LoW/tbls.version=#{version}
      -X github.com/k1LoW/tbls.date=#{time.iso8601}
      -X github.com/k1LoW/tbls/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"tbls", "completion")
  end

  test do
    assert_match "unsupported driver", shell_output("#{bin}/tbls doc", 1)
    assert_match version.to_s, shell_output("#{bin}/tbls version")
  end
end