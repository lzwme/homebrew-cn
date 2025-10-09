class Tbls < Formula
  desc "CI-Friendly tool to document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://ghfast.top/https://github.com/k1LoW/tbls/archive/refs/tags/v1.89.0.tar.gz"
  sha256 "4a738ad94c23db626ddbf70ea3b6229158dcb301217bf950d1c9641596bae86b"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7a98444c70dd18f6409a82c0f8f609cef7a4b232c18d329063e3d7a2c4c4ef1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a51200cea7d6210e20a7dd02f72b1224bc596848896799140f8d0e113c990ab9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5f72b5596717cc86e0f49043c1578f17b2c02b4f04eb7294255966d4706a0d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbdc604870d201e8cdb27558bd05a6edf9206e56c812181cbe5980b4983fc915"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5c0b94bee79af996482c938316c4fb8de30cd4aae9b22cbc81fa763414b2227"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0abb1adc65cfeb397e56b3bc6872993474d5759fd07d8dd1845fc17e15f8b4d0"
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