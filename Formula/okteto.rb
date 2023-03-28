class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://ghproxy.com/https://github.com/okteto/okteto/archive/2.14.0.tar.gz"
  sha256 "27ae03c5dc24c29658e2925f5ed87210103c0598875514d6a596ad7a048aef23"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7175ac156aeca02df8b6abef7502ecc3410dc9dd55d0ca8e75dada01bc3a9fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aace8cef2e0260eaba65b524a5559075087556b84071d32c254d90261345345c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33889f5de7449f8250ae94f16394333e5cbcc7c88f46a07fada8a37604bd891b"
    sha256 cellar: :any_skip_relocation, ventura:        "b91d704750c56de049ce7eec18451c228cf276eb6bd41c9cda62c9041ffed647"
    sha256 cellar: :any_skip_relocation, monterey:       "f50652074e536605c2afee66488fdd01e4655513b16ad68d827816a4189830df"
    sha256 cellar: :any_skip_relocation, big_sur:        "799f6c88386c3990774119d388b6e090016e8a929ccd44a0034e286033135cc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "519baa148ac844f2093584397985ab08f4ee2807ade3d3af16292bc0bd55c3fd"
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