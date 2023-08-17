class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://ghproxy.com/https://github.com/kubefirst/kubefirst/archive/refs/tags/v2.2.8.tar.gz"
  sha256 "78f58a3461913693d60697ef93ac2de2e7923649c7dd38976bdbd56bccf2a907"
  license "MIT"
  head "https://github.com/kubefirst/kubefirst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "022690913619b4e3faf8bb57358b49bcdf9e2f60a71e5a7498f1dd03d4ccbb08"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7222a0aa0dfd24185b27b858d952f5740572f4204ca67e48ff11a96be847dd60"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5ae9965324d8c599eeb1c8737beab2f5838af12e219a74f4f43e482a8820f06"
    sha256 cellar: :any_skip_relocation, ventura:        "a4e89d914e901ebdef9dcf6aba0d4387024a39eac6fa337ec89d933fe4c2fbcf"
    sha256 cellar: :any_skip_relocation, monterey:       "6721ad7b960f519d77400d6d936af50bbb03621a3c85946e2c1d4754e2bd544f"
    sha256 cellar: :any_skip_relocation, big_sur:        "9751c26f3e54035658d7ab719a0fa11acba2ccab3a5d7a80a46d0a3147527116"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8962cdedef3942c339474e9568e35aa3158fbcc7a78fd09ad29332277a156f52"
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