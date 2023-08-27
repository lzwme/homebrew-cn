class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://ghproxy.com/https://github.com/kubefirst/kubefirst/archive/refs/tags/v2.2.12.tar.gz"
  sha256 "10a2e8afc73391e4f310ba243072f9d8699c90c4b5e3f97f4d3127e7b9f6284c"
  license "MIT"
  head "https://github.com/kubefirst/kubefirst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1c1615b127a29386fde17e8c6bfaf825b5cb9f84dc53330f44678839a44339d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36ac500bd4837617c8e077e0821ec29296a4d386fb423e4dce14e49c472e0c51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5124bc2803b3c5de76292ceec64bcda792d03a05b9c4242fc17c6d13327b969f"
    sha256 cellar: :any_skip_relocation, ventura:        "41d19d5fddbe126e467579a55d6fcdf9a9071a4c1ccd73228fcb6d36dd2df2d4"
    sha256 cellar: :any_skip_relocation, monterey:       "b05358e68fd4fed835fb52f4a883e74cf122b39cec99bc6585810d49df831b0b"
    sha256 cellar: :any_skip_relocation, big_sur:        "aca98fb5d4fb4c9247f44d28ef3182833907fc694ee0e0fb0ce6f6ae0dcf2ad0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe51ec9658d260420b3922bd87b68f65ea430ea37e88dba9dd1c8c6d27d31c0e"
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