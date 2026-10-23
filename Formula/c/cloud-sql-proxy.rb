class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://ghfast.top/https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.26.3.tar.gz"
  sha256 "7f9721d813ce628f311fec574484569e852a8f92c0220471fa49d335276f2979"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c2a458590c9057fbe10dff81018d89879617e43d3b4c05b8f5aa8a7bd86cd1d6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fa7dd4c7dbb62a7bbe2a3f93c04db4df1ac023593792002d757fdb2517b58043"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "aaea91c1292b34d4880f85ccf0015be01fe7c2ba45730865f728106904f077ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b13acb26a1373d59e75fae7418a8fe244ee39b2b3524bcf92b7e61b829b9c255"
    sha256 cellar: :any,                 x86_64_linux:      "4a4bed0e0225df45460a09931d3845f1e724b230b26faa329a0d5ea99528da8a"
  end

  # TODO: unpin go@1.26 when Go 1.27's ML-DSA ClientHello no longer gets reset by TLS middleboxes
  # ref: https://github.com/golang/go/issues/81199
  depends_on "go@1.26" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
    generate_completions_from_executable(bin/"cloud-sql-proxy", shell_parameter_format: :cobra)
  end

  test do
    assert_match "cloud-sql-proxy version #{version}", shell_output("#{bin}/cloud-sql-proxy --version")
    assert_match "could not find default credentials", shell_output("#{bin}/cloud-sql-proxy test 2>&1", 1)
  end
end