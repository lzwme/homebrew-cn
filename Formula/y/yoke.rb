class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.18.0",
      revision: "16cd4aa6fccc1d516914da999f7f960f292906ff"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f5c50fd4a513f561dab56de754fceef0b87339437b1639fd07f8d7dce6cc44f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de55a2d96d60ac025f286fe2277c8a89440b8bfeeb1f5fdc6647e9bff02e3587"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a55087afc89958668b1c550efae3b10e4c811138c044dbd6e732fe8f7450866a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d1a746a4ca1587919aef6f0799208b6c68f223c03efe2376f28660b587ab672"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36aa6f5f76910ebb966bbde0cd5eb3c1fc007c497f1afcf52964d36005963803"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a03c9b212d50b00bd46a19b7aef5887681c574ded8af3087f755bcf1a69e30c9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/yoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}/yoke inspect 2>&1", 1)
  end
end