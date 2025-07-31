class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://ghfast.top/https://github.com/anchore/grype/archive/refs/tags/v0.97.0.tar.gz"
  sha256 "0fcbed7689d416c5351d2898f29fe6cf57ea2066ca0412550af41025b04b9906"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2f5825def1630841d866bf03bb05ec65e02b441c2229395c6dafe19552e1c92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc8c3886dca6b1d93be4832fc04072dca0a221ed9cf37ac97a2080e984076b30"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5608fb780a2427afe78b7392a6f9d5207fdfb2cbc1f278a291977855f8e553ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1a6a85c405320af15ecd3552c754142b3d5cf6f98d75d1f9b8665417f32a318"
    sha256 cellar: :any_skip_relocation, ventura:       "e6d80316a5a5a018f9d4770403e4893a56441b3d6fce0806ff6c832136111cbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d6c7b9ce85aef05d387d1c6c676ef4304a99fa07bd08153702655be2bf90646"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3beaa4facb358e29b4603c5967fc37313b278ff96c85ae0d01d2706ecf5708a2"
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