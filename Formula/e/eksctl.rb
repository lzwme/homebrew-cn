class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "0.222.0",
      revision: "c53a3a5b27a8bfb6fee25ee21c4b8ecade1881dd"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b335f8db0b3b3eec7f3ca8e9c42be7a99f15eb4bae3daa4de9200b523d47753d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e25e4c3584592840ca5c80ec0aa95a7b3b7b6cd707d2eeb047921c2b10eb51bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60053c090b3c351f8a958a42c454714b8df3814212c0ea1c35f7dc2756cd59af"
    sha256 cellar: :any_skip_relocation, sonoma:        "194fa3026d7efb05e7389993d3d4967a0b88fe46776cdba60302c09a502e263d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07a5d6792283df7f12710d68838dc32c9a5c8d70f0052bae2d12ec681da303b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63ed47a91401c8292bfd96cf13b66829987f47e0f19c643256218c20b914036b"
  end

  depends_on "go" => :build

  def install
    system "make", "binary"
    bin.install "eksctl"

    generate_completions_from_executable(bin/"eksctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end