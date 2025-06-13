class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https:github.comGoogleCloudPlatformcloud-sql-proxy"
  url "https:github.comGoogleCloudPlatformcloud-sql-proxyarchiverefstagsv2.17.1.tar.gz"
  sha256 "8c48d9724e2084cabf7f001fe2cbd9dce33143dd720e55797fa4b15fe6921e66"
  license "Apache-2.0"
  head "https:github.comGoogleCloudPlatformcloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f01281f85a4a92e46ca09ae4766e9a96d594eec4d4e638edfa5ad044e08422e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f01281f85a4a92e46ca09ae4766e9a96d594eec4d4e638edfa5ad044e08422e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f01281f85a4a92e46ca09ae4766e9a96d594eec4d4e638edfa5ad044e08422e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2ad4bed950ff0fa371a1715773dd5e6ae10ed44e2a56d01eb81971053f3acfb"
    sha256 cellar: :any_skip_relocation, ventura:       "e2ad4bed950ff0fa371a1715773dd5e6ae10ed44e2a56d01eb81971053f3acfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "677c114559ba63405943c0cb1f6af74bf27b39034e4e96fe91d66d384e83bea1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "cloud-sql-proxy version #{version}", shell_output("#{bin}cloud-sql-proxy --version")
    assert_match "could not find default credentials", shell_output("#{bin}cloud-sql-proxy test 2>&1", 1)
  end
end