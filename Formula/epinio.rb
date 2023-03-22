class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://ghproxy.com/https://github.com/epinio/epinio/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "61721f2c6599358353eae6325c1ea4ba769cdaee29f1e5602bb0fc279dc65cb0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47f2b7176f148d2de36604f84e2ccea7171320af6455d5396f1c788b1bfdc0eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5d77c7dc055d802805f3f76a9fd9b8557651abddd0d4f93d8a589290ec4ef4f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65dcb228f5ea0aecb2c3ba1d85624eac98d76e8c15cf87b2209683f1e7896dce"
    sha256 cellar: :any_skip_relocation, ventura:        "05b4a6d9fd078f09afdd3f037a7b3bd420c25ea25b4e4282a9d90ee711f95165"
    sha256 cellar: :any_skip_relocation, monterey:       "8d1474f7f9b47570521502580304b3f00cb6ea4b21d4a0683c3a52eba22ce89a"
    sha256 cellar: :any_skip_relocation, big_sur:        "d05de4f6b6c43da844db409e8c907d10144259498f559b19ed1364981fbd8e3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbb9bd723cf1ad7bee7889ad495ead2ae4d1f30fedc721f7c6993361ffa9ce0c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/epinio/epinio/internal/version.Version=#{version}")

    generate_completions_from_executable(bin/"epinio", "completion")
  end

  test do
    output = shell_output("#{bin}/epinio version 2>&1")
    assert_match "Epinio Version: #{version}", output

    output = shell_output("#{bin}/epinio settings update-ca 2>&1")
    assert_match "failed to get kube config", output
    assert_match "no configuration has been provided", output
  end
end