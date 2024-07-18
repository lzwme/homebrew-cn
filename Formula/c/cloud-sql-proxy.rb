class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https:github.comGoogleCloudPlatformcloud-sql-proxy"
  url "https:github.comGoogleCloudPlatformcloud-sql-proxyarchiverefstagsv2.12.0.tar.gz"
  sha256 "19a59540ea9498d280c8b5e01644bc99e1e3928679ded452a13259fd2e6b4346"
  license "Apache-2.0"
  head "https:github.comGoogleCloudPlatformcloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c16f9aecfdd96fe57b87262bcee96f72f7efc5522511278761208612aba70e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d418f934cad8eb965fee27cdb0782922125256056b6f0a3dd627b4ab67484c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a19b035a8283259a481c81f6a80bc085c569b001182fbc621d0993d1fd7337d6"
    sha256 cellar: :any_skip_relocation, sonoma:         "af92f01a4ee248cf0e34893ce244a5b598092fc6052806f584ef319ed30c421e"
    sha256 cellar: :any_skip_relocation, ventura:        "5b3ad3a5dc85555e798d79eee255fa6a2a7660f90b671914182edf9958d1a89c"
    sha256 cellar: :any_skip_relocation, monterey:       "2e0b72fed67ebeda7b6e62086cb89a6c12f3943815ef997f7e639091a0265018"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d8df2e8054347d5c5fce3ce626b93102d54aeb7e3a6a205ed85e0354de06b36"
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