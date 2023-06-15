class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://ghproxy.com/https://github.com/kubefirst/kubefirst/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "b0d60e61ae27022bfc219c85530cce9f903d628c027575391528ad00824281b8"
  license "MIT"
  head "https://github.com/kubefirst/kubefirst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c7ac8bcd12e3457e1afb7088f42536cbd85ba142154868731ee01241849504d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b6d082c0b0696a726de36efec37fd0f37afa80b8894d6b2f3ca2fb72f0bdd4f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d3a46b7b808bfb20af8a24b866f827854741c421072fcde04bdc12e1e501d3b"
    sha256 cellar: :any_skip_relocation, ventura:        "16811ad2d7731f596712680ffa22a73f179d0b18a60f2344e5b39de157921603"
    sha256 cellar: :any_skip_relocation, monterey:       "46b9790dd50812d0dd6cf76f2f6f49b8d28f278e44e7acae9bdd10efec7046fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8c5e5d71f904404e54a2d592f3c0bef99e544d7dd5c698c81a22b7c325c7fa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1858e43703142ae96b39a999e032afc9793f227b72be89bd815853b0aaaaeda9"
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