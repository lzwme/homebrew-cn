class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://ghfast.top/https://github.com/goreleaser/nfpm/archive/refs/tags/v2.43.2.tar.gz"
  sha256 "906c313dc719c6a63c78d47dd9bdc11f8e5440c550d34013ca612d570b3fcaa0"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "731050be71c1ac2be8804982b62fc7ac58b6c55603448ab193c63d181c681f1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "731050be71c1ac2be8804982b62fc7ac58b6c55603448ab193c63d181c681f1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "731050be71c1ac2be8804982b62fc7ac58b6c55603448ab193c63d181c681f1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7038ba87e5260695af43997fddb99981f98f92463fd92761d413c2b6f520a932"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1476ccb0db77febfc50f7a279f14823b7ec762e82c4aa52be1e9c1ed0a0f1013"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), "./cmd/nfpm"

    generate_completions_from_executable(bin/"nfpm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nfpm --version 2>&1")

    system bin/"nfpm", "init"
    assert_match "This is an example nfpm configuration file", File.read(testpath/"nfpm.yaml")

    # remove the generated default one
    # and use stubbed one for another test
    File.delete(testpath/"nfpm.yaml")
    (testpath/"nfpm.yaml").write <<~YAML
      name: "foo"
      arch: "amd64"
      platform: "linux"
      version: "v1.0.0"
      section: "default"
      priority: "extra"
    YAML

    system bin/"nfpm", "pkg", "--packager", "deb", "--target", "."
    assert_path_exists testpath/"foo_1.0.0_amd64.deb"
  end
end