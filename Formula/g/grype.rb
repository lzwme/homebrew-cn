class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://ghfast.top/https://github.com/anchore/grype/archive/refs/tags/v0.104.2.tar.gz"
  sha256 "da7da41b46fe4c42dad97294ed742490cd268db682dd0b1eb803f5d00ca0fe8f"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d072ed3b218298ac92c8ef7ff38c816f6ca48660eea3f40adf69ad5ae580770"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8854b2b2f16a66a8870871bc3ff55967759defa931d84525757ff90ea3e0d1cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6eba04a965f1eae4308c1e2d86e813634abbc1a4727dcae959c290fad2379fae"
    sha256 cellar: :any_skip_relocation, sonoma:        "eeda3d9b6968e67ea4c84e92d15330b2cb3b684a7aa5ef9154f4897f0b69266f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d304c0c315d2063e2b4954d6e4e5e61b55058ea3bb2684e3fe225bdfedf24f06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af69adc6b2b2061536b7cb3886cb20283b3c97f33ea652cf094c1c1bce143a96"
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