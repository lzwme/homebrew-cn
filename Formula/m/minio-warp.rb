class MinioWarp < Formula
  desc "S3 benchmarking tool"
  homepage "https://github.com/minio/warp"
  url "https://ghfast.top/https://github.com/minio/warp/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "b76116e34897c98a4cf8903d5b8cfde14bc0a2a39208027c2690c2b6f5e4f088"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/warp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5468e5851d3235cabf89aa568b8907f96ce490f79b8ad88f7118ada51db4a985"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c7440392f8fa853b0e1e8a5c8fd6fb5d4025deb4468d01003d0b357189c4154a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6f14f709f25957c7564ab32b49eb78e906f7d9c982efeb6c7ca05795500f6dab"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6673e643e4e3a8fc551f3176551f4f7e8b0be839244bd33f62ba4fa5f1876b4f"
    sha256 cellar: :any,                 x86_64_linux:      "282eabd0b64b1b8af3e5657e60505e7ea210d4e842cbaec1d389d625578cd524"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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
    output = shell_output("#{bin}/warp list --no-color --quiet 2>&1", 1)
    assert_match "warp: <ERROR> Error preparing server", output

    assert_match version.to_s, shell_output("#{bin}/warp --version")
  end
end