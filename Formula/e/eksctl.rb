class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "0.221.0",
      revision: "de9424a29cd8108ff4574d54844e4e98175efac8"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d269272ee4c1bea0f46fd4ec25c9161563a957e387a2dd1e2bd5a57802024a8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34fced9bc1f4b403df7f5f80f7491db0048ebc1458e969e4a21d698dfb988623"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5c9b6ca5e70a837f4e54980ebb59d8ff3bee63bf0418eaed64da9c1d068b0a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "140a8b92305310e7ed3e2d260fdb44df7e45879d7fb252f84e49db9acdfa98b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4f9ce77c92f517aea34f70845480a81c69d80b90b4e1232f0d2cf9fded5e150"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edb08664649f1d3cc74bc6107ad4b88fe781ded90956851e252025bfd9b7af8b"
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