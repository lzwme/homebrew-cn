class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https:nfpm.goreleaser.com"
  url "https:github.comgoreleasernfpmarchiverefstagsv2.34.0.tar.gz"
  sha256 "0ab290538866352d8b13a18f211dfabe6af1bf02addec87b234ee580ace70e65"
  license "MIT"
  head "https:github.comgoreleasernfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb3994f57fb0f710b404dbe85e18cd8432a7c853cc8004f5d009ebeef6287812"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f787f2709f341646f369c505b2a2e48f60a26dd9a3dc0b8660c26121ee9c27b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d614b910d1a2d0dc2ab23cce967fce8decb1c2c70009f4090c893b3e6a212801"
    sha256 cellar: :any_skip_relocation, sonoma:         "bbdb9d4c99a9c34429b5c34c2b1df7064c22b3fcb086bf66142483ff29e04cae"
    sha256 cellar: :any_skip_relocation, ventura:        "7aad7ebe8f5c72f374fc03dc6fe5b0488a6c6986ddfa2a225d389d7b96f77458"
    sha256 cellar: :any_skip_relocation, monterey:       "fe2fce66116bb7fac5704ca39742ed2f9c0ccab592ba13d340916af5001f32eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a19a17bcc59aa98dc14a4b129308f83f7a0f200f4eff9af3e095a9c1733a2035"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), ".cmdnfpm"

    generate_completions_from_executable(bin"nfpm", "completion")
  end

  test do
    assert_match version.to_s,
      shell_output("#{bin}nfpm --version 2>&1")

    system bin"nfpm", "init"
    assert_match "nfpm example configuration file", File.read(testpath"nfpm.yaml")

    # remove the generated default one
    # and use stubbed one for another test
    File.delete(testpath"nfpm.yaml")
    (testpath"nfpm.yaml").write <<~EOS
      name: "foo"
      arch: "amd64"
      platform: "linux"
      version: "v1.0.0"
      section: "default"
      priority: "extra"
    EOS

    system bin"nfpm", "pkg", "--packager", "deb", "--target", "."
    assert_predicate testpath"foo_1.0.0_amd64.deb", :exist?
  end
end