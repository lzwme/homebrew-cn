class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v2.2.1",
      revision: "12cbf9ea177d22bbf5cf028bcb4712b5f174ebc6"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0cb4c26782bb2461ae1c5663e0039570341e02597fa323584f2ea69e19578bd7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4269e3c4429ce1700057a9dfd10a61d4558c30f25d668b1740efda22bad786a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1547269d20758ac24bc03f6e899326a97b7b26f0757f88f9a01a08f4cc2f47a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "8cd63572bdb9b39260ed783b6ea0d13674d9e923ebbe4376f00fe6b1e263984b"
    sha256 cellar: :any_skip_relocation, ventura:        "7a6da3b1a9f28d3bbf560b9c148a6a7386bfcdd0aee998cede6451ae2c6249cd"
    sha256 cellar: :any_skip_relocation, monterey:       "eed5d0a6be5f2f227df044fc85618ab01a78f62ffea35e88dfd4db5562aa161e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8ef6c8273fb0667fa31332c1520e92a2a05db190548e1b829d6cc590912007f"
  end

  depends_on "go" => :build

  def install
    pkg = "sigs.k8s.io/release-utils/version"
    ldflags = %W[
      -s -w
      -X #{pkg}.gitVersion=#{version}
      -X #{pkg}.gitCommit=#{Utils.git_head}
      -X #{pkg}.gitTreeState="clean"
      -X #{pkg}.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/cosign"

    generate_completions_from_executable(bin/"cosign", "completion")
  end

  test do
    assert_match "Private key written to cosign.key",
      pipe_output("#{bin}/cosign generate-key-pair 2>&1", "foo\nfoo\n")
    assert_predicate testpath/"cosign.pub", :exist?

    assert_match version.to_s, shell_output(bin/"cosign version 2>&1")
  end
end