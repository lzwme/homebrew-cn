class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://ghproxy.com/https://github.com/okteto/okteto/archive/2.18.0.tar.gz"
  sha256 "babecece38b11737c91d0466cb877f043d52c4635fbe64d1940cd866194a7569"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e4d8e8e5c9be8d1cd22bd051fe51087fcb19821c81d385af8c487cf6837fcfa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f4cb0396eb71a166daae8c9e3f9dad62dd01319691e6cc57f31ab92a6bce4dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24868eb5af17c284bee05001a05e1577f795a348c2e1ef8830d7567c02e24056"
    sha256 cellar: :any_skip_relocation, ventura:        "8f85cd1004de94ef6e069b2b3522225f7d8a79c559431f5177f2653f6898322b"
    sha256 cellar: :any_skip_relocation, monterey:       "16f9eaaf63a3dc66131043d4ac37d937cb4a966e4933df2169018cc681b868fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc6dfb1f89c3a669d296a3ada447a0125901dacc0d442bc3ee456b51b6bb288f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b5d9f60a5cff7678d9f6567f852d0330b375dc8c2c7dddce10e84a34643c385"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags

    generate_completions_from_executable(bin/"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin/"okteto init --context test 2>&1", 1)

    assert_match "Your context is not set",
      shell_output(bin/"okteto context list 2>&1", 1)
  end
end