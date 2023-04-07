class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://ghproxy.com/https://github.com/kubefirst/kubefirst/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "2fbaa5c05b159f11f5cd677bbd99cc62c3f42a964b8f3920d7322ce381f48528"
  license "MIT"
  head "https://github.com/kubefirst/kubefirst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7bc59d958d2b18c0bf55833cea63151f90f5aa8be7206e88206ecd480cd378d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c7b9ddbf441a1280bdbb2c15750003b5df93112063ac75b24c7304e85349865"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52066315267da99a862ab55e190708a07dc54ed54b602788f7dc8744e0684c5a"
    sha256 cellar: :any_skip_relocation, ventura:        "2d3fc1db6167d742c4e9f28968efbca3b9f78ac78ee00c04c108db3afe615980"
    sha256 cellar: :any_skip_relocation, monterey:       "a43f4efa5b0e239e2ca104462640b945627e0cfdff99fcffde617d048f826d91"
    sha256 cellar: :any_skip_relocation, big_sur:        "318e3ac87361b6de82d47fb64300fe00d4f4fc187c0dcdce12bb76b428ecfc48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6adacf3e9a49fa072609a1368c11efe608a07d7a88afe6db82a67dceaf733b0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kubefirst/kubefirst/configs.K1Version=#{version}"
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