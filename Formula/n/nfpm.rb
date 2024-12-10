class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https:nfpm.goreleaser.com"
  url "https:github.comgoreleasernfpmarchiverefstagsv2.41.1.tar.gz"
  sha256 "6fb9713f5b3ec4e44c256b2b22505eb13b8e53a1fa95dc6044a7b7ec2ee9e754"
  license "MIT"
  head "https:github.comgoreleasernfpm.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1c4e05ae002983dd31d12081a583b3f1bc905e640b202f9bd190d1de4d2c70e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1c4e05ae002983dd31d12081a583b3f1bc905e640b202f9bd190d1de4d2c70e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b1c4e05ae002983dd31d12081a583b3f1bc905e640b202f9bd190d1de4d2c70e"
    sha256 cellar: :any_skip_relocation, sonoma:        "28358161456f6ba210fd3d05ef62266a110c7eeecd7aa1b7c154a675a619d02e"
    sha256 cellar: :any_skip_relocation, ventura:       "28358161456f6ba210fd3d05ef62266a110c7eeecd7aa1b7c154a675a619d02e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c47d7889d1471ed0f96deb25be8b691c47333b1e6bc29dce1a293d76ebb601aa"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), ".cmdnfpm"

    generate_completions_from_executable(bin"nfpm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}nfpm --version 2>&1")

    system bin"nfpm", "init"
    assert_match "This is an example nfpm configuration file", File.read(testpath"nfpm.yaml")

    # remove the generated default one
    # and use stubbed one for another test
    File.delete(testpath"nfpm.yaml")
    (testpath"nfpm.yaml").write <<~YAML
      name: "foo"
      arch: "amd64"
      platform: "linux"
      version: "v1.0.0"
      section: "default"
      priority: "extra"
    YAML

    system bin"nfpm", "pkg", "--packager", "deb", "--target", "."
    assert_predicate testpath"foo_1.0.0_amd64.deb", :exist?
  end
end