class MinioWarp < Formula
  desc "S3 benchmarking tool"
  homepage "https://github.com/minio/warp"
  url "https://ghfast.top/https://github.com/minio/warp/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "c99bdb158e46e96aca9092b7d5fd6483e3901093045b1c8e987094d1fec94f2d"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/warp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9224153235f18d539966093127aa07bffd8b9cbf7b2ac97cdbad5e2e81097b9a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "54fbaa578d3bf067d7d84d6a1b1c027d7c6cddf888319d99f465d642b37fce29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "075160b6193d1af54cadad2c8bbaabbd630e4cc1e0730ce88e27c149742b831c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "b25a218f0100b4b3e682e668efb082f219fb6d13fbeb95a6568c8361fe70c10a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a6b63deca34c56435c0e812d29b8ce358ad6c888a21f8f76de403253f0e877b8"
    sha256 cellar: :any,                 x86_64_linux:      "a339847bac2f4e36eea517e51cbee48330e5d0a1710f05bf64519c3ffd2090b4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/minio/warp/pkg.ReleaseTag=v#{version}
      -X github.com/minio/warp/pkg.CommitID=#{tap.user}
      -X github.com/minio/warp/pkg.Version=#{version}
      -X github.com/minio/warp/pkg.ReleaseTime=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"warp")
  end

  test do
    output = shell_output("#{bin}/warp list --no-color 2>&1", 1)
    assert_match "warp: <ERROR> Error preparing server", output

    assert_match version.to_s, shell_output("#{bin}/warp --version")
  end
end