class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https:nfpm.goreleaser.com"
  url "https:github.comgoreleasernfpmarchiverefstagsv2.35.2.tar.gz"
  sha256 "b94e49a0b57e28f4c73f28ef1518106220a8fdfd0fa586e7a3c2792a08ea0c7a"
  license "MIT"
  head "https:github.comgoreleasernfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ec869ab6cb9216d464898a137dfe019c8f6e0642def072cb202a49cc3d27a108"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ac2cac8089a682033c9e3f95b1ed62ea1a0c7b9f0f1746e50f6074603955be5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74a55568ef9d8542fade37bfdaec4a5e9f5991431e6dc85ca80c3480491e61c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "3575caf6ac2713bbc3ce7b4aa84702e70f15a4ad79d479a25c5d7689ceced6d4"
    sha256 cellar: :any_skip_relocation, ventura:        "47c801845e8db75df1725413929c3d08d29d80af42589141931744cdbd181d01"
    sha256 cellar: :any_skip_relocation, monterey:       "72654cbbec269d26f68b0dc45d53b6051e906c830c727a4cffc3a230442194b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "166ec4e441b52f09611653992b2cc86da5e4021e4dc7a329414f9d376b1b3dca"
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