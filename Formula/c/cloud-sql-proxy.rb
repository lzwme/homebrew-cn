class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://ghfast.top/https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.26.0.tar.gz"
  sha256 "847959e97723aa25513b73812f6a323ada28c616c02677838bdfcb4842bfd67a"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9c6c78c84dcf0a48a373aa645f2b998a81713951c6ea88906e1f8c4248d408ed"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "63b5d95de7ed829c4226681747728c4584f86572bc9fb581946f285de714e9dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "21a4f45b76b78e7296f450078febeddad3c48d9c374611abb2936193c220280d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3f11fa4e0887e723faa2fde01c92138874cac057fb5525ec749b33ada56bd886"
    sha256 cellar: :any,                 x86_64_linux:      "601aa7a05a37b1589e21a25a90fd700892ab454e60ce21a20036a61547888af3"
  end

  depends_on "go" => :build

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