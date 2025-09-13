class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://ghfast.top/https://github.com/anchore/grype/archive/refs/tags/v0.99.1.tar.gz"
  sha256 "0f5e294615013e4f4a757064540696e52546c1b8bdef65ea9b1ccc3ddd49d39a"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e20983844378c49b7d28763e9ef23d1f53cb80a3e3bd5449ead9b533c91204e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59e93cefcda048e8a09517f9623b6aa542e904e893bdb73e989ddb1d369559e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91be6693d2d1c60fe2543b6d1d3ed719a45d0fcc5874f7a2a0a94a9dd90bf3b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ce1c005ba0ad1f6d101f197c3d4367e7f134b8973ea4125efce2eb63b6cd3c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "21cbe3bd3bc660a007154abc215638f8555dc5d363480544729757cada0528e9"
    sha256 cellar: :any_skip_relocation, ventura:       "547d4506885df3235e2cffe18a604b85c8d502c8b299c3ad1cf96e8784f56810"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b770c3490ac22e9cdb5a0c590ceb75be7e48ec67df750327c89f5831ab0590dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a83d9f682cc86b256be152fbf9b2f2cc742673f5045675e4ecb7f507a27c4b2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.gitCommit=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database does not exist", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "update to the latest db", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version 2>&1")
  end
end