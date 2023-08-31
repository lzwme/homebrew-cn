class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://ghproxy.com/https://github.com/kubefirst/kubefirst/archive/refs/tags/v2.2.16.tar.gz"
  sha256 "94edfb7a132c5ae6761df232188beef174947afaddefff95ec7a1ba84ef1f31e"
  license "MIT"
  head "https://github.com/kubefirst/kubefirst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1210a9a55ef3992c560aed04d58ce6bb9cd55623d53c97a1bea4f8e983808be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "821bd2aaea39dc4ea7efb9e544afb4f618b73d2bd32b79941875404a17475d88"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77f2c6b4970dbcaf261c1d46d16b7ee79d2eee1a31ed0327357015c401ecc535"
    sha256 cellar: :any_skip_relocation, ventura:        "99bfbd90656a30a1ecea262014d98e4c6d3c4a23fc69e36775bb1436ee104b22"
    sha256 cellar: :any_skip_relocation, monterey:       "856c53439df6e622017587ab2b77835067f45d2f54b12a0f7b57c59c96f74406"
    sha256 cellar: :any_skip_relocation, big_sur:        "f07c6fa9e155514cb48da76e3396439af3c4954b4304fd5321a4bad92f7d9f92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7647b4c6bea8c56bd48212d6315c0ba2f976b2caab455e9cba309dd1f4e3a02a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kubefirst/runtime/configs.K1Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kubefirst", "completion")
  end

  test do
    system bin/"kubefirst", "info"
    assert_match "k1-paths:", (testpath/".kubefirst").read
    assert_predicate testpath/".k1/logs", :exist?

    assert_match "v#{version}", shell_output("#{bin}/kubefirst version")
  end
end