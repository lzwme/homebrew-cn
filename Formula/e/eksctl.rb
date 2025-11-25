class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "0.218.0",
      revision: "2c98d61aaf5c1c74b1457854e718bacbeb7290c6"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b74c822db8d2e31c2a6e42a3450e85eafcf765111087928a52c2428861d2304"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd31d7b6e71653fb625eb17d1bba6a9b5cf4cb3e5c52f1cdf9aa56650b23e8ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24edac36a3683f960fca7cd2b62cc054511d7b21051d74e38780085386aa878f"
    sha256 cellar: :any_skip_relocation, sonoma:        "87d96066592193ca4bb7abc05d275e7187637e7530df228310bf05d437ca2085"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1283f7e414eb4b1543e97d8fa60d6e858e8c2d2c5afc8e04ab3f0b41bcd26504"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "052f8d504350f1074be97b28c54fb76edaa346682c6a59359c0859d94c527da7"
  end

  depends_on "go" => :build

  def install
    system "make", "binary"
    bin.install "eksctl"

    generate_completions_from_executable(bin/"eksctl", "completion")
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end