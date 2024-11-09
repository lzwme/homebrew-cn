class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https:nfpm.goreleaser.com"
  url "https:github.comgoreleasernfpmarchiverefstagsv2.41.0.tar.gz"
  sha256 "c08841bdc89373123280f6a2a48775981b70301241bfce4743d2a676394a16cd"
  license "MIT"
  head "https:github.comgoreleasernfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3981673dcb67d44ea45bd37d0b76a6dc32b32c595822b7b416d596ce3ac3482a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3981673dcb67d44ea45bd37d0b76a6dc32b32c595822b7b416d596ce3ac3482a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3981673dcb67d44ea45bd37d0b76a6dc32b32c595822b7b416d596ce3ac3482a"
    sha256 cellar: :any_skip_relocation, sonoma:        "39508812fdafec13c0ecb75038327679995aa929cc41d4dd9907613abde6803c"
    sha256 cellar: :any_skip_relocation, ventura:       "39508812fdafec13c0ecb75038327679995aa929cc41d4dd9907613abde6803c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c56bcda788fad11ef7e22633c0222854fe41247d0ead4e039a19b39ef71cbe0f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), ".cmdnfpm"

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