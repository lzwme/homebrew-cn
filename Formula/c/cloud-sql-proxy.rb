class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://ghfast.top/https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.18.3.tar.gz"
  sha256 "9ca2cf637206c2bf0fb1e7f980a3fe8159824703b42231ca483ccba3de4d710d"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b32d5d86a6fbc43c0a8da8d1b5770aac07591b25c167e5f089c87be15bd36ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfe6b7dca7217595b58c5a2528ce443fff7d131744787ccfdce840416ec4a34f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "107b4683d23ebbd820e59bbaf11edda1a889954eb6b7812da7cc42126e84c536"
    sha256 cellar: :any_skip_relocation, sonoma:        "90f20c4762ead362993956169a67d53237f78badb010d7da71783d374bc9d586"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fffe5c9890793e29ebea51fdbb3a0b8b0789ae8f3ac66e77a77e3fe87c083f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9011585c5073f9268a0354bf7d4f0cff43f6fec2ff3c081ebb2ca67b57e23bb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "cloud-sql-proxy version #{version}", shell_output("#{bin}/cloud-sql-proxy --version")
    assert_match "could not find default credentials", shell_output("#{bin}/cloud-sql-proxy test 2>&1", 1)
  end
end