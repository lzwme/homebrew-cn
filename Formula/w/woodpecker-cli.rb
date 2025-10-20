class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https://woodpecker-ci.org/"
  url "https://ghfast.top/https://github.com/woodpecker-ci/woodpecker/archive/refs/tags/v3.11.0.tar.gz"
  sha256 "0e7edcae7da55be976d138ed34675be69198d24ee337b9d0588f4c0ec495c63d"
  license "Apache-2.0"
  head "https://github.com/woodpecker-ci/woodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cfadd32b5b7d7400d85eec147ab57127cdd6055baebe48eb4a4103565c5a3873"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfadd32b5b7d7400d85eec147ab57127cdd6055baebe48eb4a4103565c5a3873"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfadd32b5b7d7400d85eec147ab57127cdd6055baebe48eb4a4103565c5a3873"
    sha256 cellar: :any_skip_relocation, sonoma:        "c54c6887778be066c8fc50d45c869af71fac80f24a11e66530f7356ef77c6889"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "002c4c521c6f6efbac906113a27aa45f7c2fa785b5b9baa8372b7678e5cddc51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f68cb2f8584a01657c26dfb49b58149e2a93c3c263d33bf51ca8b0afce3da509"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.woodpecker-ci.org/woodpecker/v#{version.major}/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"
  end

  test do
    output = shell_output("#{bin}/woodpecker-cli info 2>&1", 1)
    assert_match "woodpecker-cli is not set up", output

    output = shell_output("#{bin}/woodpecker-cli lint 2>&1", 1)
    assert_match "could not detect pipeline config", output

    assert_match version.to_s, shell_output("#{bin}/woodpecker-cli --version")
  end
end