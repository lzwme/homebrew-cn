class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://ghfast.top/https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.24.1.tar.gz"
  sha256 "bef13d34896d3e250cb04edc3fd01a4b1c68934e2edd2cd6826a82c69a27b427"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dad8a0005498b32d69fd85e00468a1681e633e43115c4dadbc88f47023d3999b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28e43555313ea4d35cb47a4b8110ce41a4fcb9a22fcec786a10c1d4a18911a68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45691e832f9a6c3f1c4540835faa9ff1e8bd92d32f09228c6ac0b3b1d49ab252"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4cff0f00c939532589cb10431b993d9ee072905f1429c8cda52ba564499d180"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95cc70def5c89baa2655f5b0d1c659d8b8941b0f0c2fe68b8f7709e19a942644"
    sha256 cellar: :any,                 x86_64_linux:  "685369d3a6d1532aeb3bff2f4965e640c8b53d4dddd0f555fbf7dfd2919c2e48"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
    generate_completions_from_executable(bin/"cloud-sql-proxy", shell_parameter_format: :cobra)
  end

  test do
    assert_match "cloud-sql-proxy version #{version}", shell_output("#{bin}/cloud-sql-proxy --version")
    assert_match "could not find default credentials", shell_output("#{bin}/cloud-sql-proxy test 2>&1", 1)
  end
end