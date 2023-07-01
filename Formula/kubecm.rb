class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://ghproxy.com/https://github.com/sunny0826/kubecm/archive/v0.24.0.tar.gz"
  sha256 "18bf359e5dabecd010207ca10c39a05bfe7ed1000414d1e6138ec02639dbbdf4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "abaf90cf0f66227826281ffe22b3f27918c356181523939de3f7eeac42e2f9fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abaf90cf0f66227826281ffe22b3f27918c356181523939de3f7eeac42e2f9fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abaf90cf0f66227826281ffe22b3f27918c356181523939de3f7eeac42e2f9fa"
    sha256 cellar: :any_skip_relocation, ventura:        "2d5cc62a041d6cda3a3bab00fad00ccf74a13ab442c82424f5fcbd733445029b"
    sha256 cellar: :any_skip_relocation, monterey:       "2d5cc62a041d6cda3a3bab00fad00ccf74a13ab442c82424f5fcbd733445029b"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d5cc62a041d6cda3a3bab00fad00ccf74a13ab442c82424f5fcbd733445029b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8def5e773e956c6de9f432cc18f7a9d93f275a5e88432e29c3b4bea614a1bf2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sunny0826/kubecm/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kubecm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubecm version")
    # Should error out as switch context need kubeconfig
    assert_match "Error: open", shell_output("#{bin}/kubecm switch 2>&1", 1)
  end
end