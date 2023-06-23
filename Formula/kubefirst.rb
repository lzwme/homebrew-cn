class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://ghproxy.com/https://github.com/kubefirst/kubefirst/archive/refs/tags/v2.1.6.tar.gz"
  sha256 "d4de4d5b9d375978dbe3548258c8a4966ea4d3bb76834167a4342edd156d85cd"
  license "MIT"
  head "https://github.com/kubefirst/kubefirst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f34f5c39b56272cb12cefa85a2c60790b66b0de7358cda99f6ff6a525d91b5f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75190dfc3e1d1fe874ea995dc47f2203d09f3b2f5e69dcade4ca0ea681817c1d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb913e0bd8ecc920885af1a18e3c43780187f198a9108fc812717c06fd658d65"
    sha256 cellar: :any_skip_relocation, ventura:        "b40f6864301ebaead59c60370e2bf4c121b41f8710b92b45a33d83306272709a"
    sha256 cellar: :any_skip_relocation, monterey:       "c63803ee6ca526ca6c7af2e6d8d7cb874a8d06668c836566c7d85de0acc9317f"
    sha256 cellar: :any_skip_relocation, big_sur:        "84f62dc539a908d62afcda30cf4039d2c0ef3ff5110ca59f6ea51ef2324dca11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "669dca55b50fb222609d3d6c7dc45dc1f46bc615fc42e363e6416901452dd62a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kubefirst/runtime/configs.K1Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kubefirst", "completion")
  end

  test do
    system bin/"kubefirst", "info"
    assert_match "k1-paths:", (testpath/".kubefirst").read
    assert_predicate testpath/".k1/logs", :exist?

    assert_match version.to_s, shell_output("#{bin}/kubefirst version")
  end
end