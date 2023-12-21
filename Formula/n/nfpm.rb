class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https:nfpm.goreleaser.com"
  url "https:github.comgoreleasernfpmarchiverefstagsv2.35.0.tar.gz"
  sha256 "cd7b53f34e3b18bbe653a8441dfb72f4ca8764cceb3f4aad0c632fcccb027aba"
  license "MIT"
  head "https:github.comgoreleasernfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d08df0ffd7721709359b12731d6b364f356a03e924e8ca0b976e55e7ee79e57f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a283211f00d1ba6b70792983c0e3b11c7ecbb5e5fd3b97b9a0815d6159ab209"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb90228c2185175dbd5a105317d3b9704a19d803b6f20dd602ee6799bac4f9f0"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a8da905f52f30d205f952cd0c174486ae7a9dec55b11bdb879cadfaec5c3669"
    sha256 cellar: :any_skip_relocation, ventura:        "a5aac77811006bb6409f12ebb195c7b3c25960bda0353486bc42001bbc2936e1"
    sha256 cellar: :any_skip_relocation, monterey:       "24a797bd9c0b5a939a3c096862ba21dc239d2af483363b2e874c084edfc7d52a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7e4ac60e80c422c1d3a3685168f2df379f6cf1f8f1905ab9ef8f6c157316831"
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