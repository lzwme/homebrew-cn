class Tbls < Formula
  desc "CI-Friendly tool to document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://ghfast.top/https://github.com/k1LoW/tbls/archive/refs/tags/v1.92.0.tar.gz"
  sha256 "f442a6c9e711b8bf53ecda3b54b1a2a6b9983dbc427ab513ed7c5e909f67c964"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b754428556dc77b193ea05b992ef5fc79f388bc84dc01a691d29235f7319c308"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "989d6c2ce1443cc87b0b7fdda93ef3e5bb721848867991d70c861182a483ccb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37e5754be80e981e0bea82468bd92df2e9923e7749c159fd10cec790ed2ca08c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8216d63d7191dfb0093e9b2befdba2a2bc9b817d5219bf1424a2043e36079e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "913e951ba162dbdaee252bfcc081029e80577d19281c33c84d68982fd70b6cdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03877420a6afcaf2e20db4fe4d5e5bd3f922c8e2e9bf5cc38f80d067d2879bd1"
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