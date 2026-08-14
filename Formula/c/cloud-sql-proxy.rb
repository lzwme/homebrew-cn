class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://ghfast.top/https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.25.2.tar.gz"
  sha256 "02e705c384b31343dc664394f4614679a555591f1415c4dc23513bc55fafb5c0"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b5b612c49d8e5eef395710ecc0ab98073c4ab36de5a35f3f783ac46a51f9b7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c38aacce69480a19044b9a12da88f1c6701a247dacbb743117c042e08e3394b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ef3386705fa4ffcaace69d9e09c72ffbd9fbe5f31ef969f4339f34e90d61820"
    sha256 cellar: :any_skip_relocation, sonoma:        "02b86d95ae6e983f5b0e21e45324f2566f4fa4ebc2289b09dd7ed68429642722"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c248a7d369416aea6c56f4467047e07cf797a9c2c709b4272aed4205da2c6bae"
    sha256 cellar: :any,                 x86_64_linux:  "26ed3947cf923688937d2d27b591630af8cfe3946948bb072477e52482845d5c"
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