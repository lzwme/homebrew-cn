class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://ghfast.top/https://github.com/goreleaser/nfpm/archive/refs/tags/v2.44.1.tar.gz"
  sha256 "0c663bed40ce3f39ba605f7fe7f536d5474ddc0988d0ea745e62fb72b3650dd2"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de2fa21f319ff61da4a4a4f895a2a61810f3a1c8e4355342713d3e83df157c00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de2fa21f319ff61da4a4a4f895a2a61810f3a1c8e4355342713d3e83df157c00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de2fa21f319ff61da4a4a4f895a2a61810f3a1c8e4355342713d3e83df157c00"
    sha256 cellar: :any_skip_relocation, sonoma:        "03034e4eabe87f50632c98468a0b3446bf9716cc83c681a7035491a18d5f6678"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f731b5d04bee00de1dfb0143048d281909658317f9fbe12615beadfda10a5d1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a40e3ed2faf03dd0c267166897c8bda9fc72608748f6723cd9dcf01e6a07a66"
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