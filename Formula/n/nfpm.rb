class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https:nfpm.goreleaser.com"
  url "https:github.comgoreleasernfpmarchiverefstagsv2.41.3.tar.gz"
  sha256 "d0db58214c2a40c9fd31a212428e65dbac423fa0926cc47f5116a1cd5ddb06ad"
  license "MIT"
  head "https:github.comgoreleasernfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d1eac5abc0f1538a3b29964d89180274b4746b4d8a3f415d5c02febf28eae79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d1eac5abc0f1538a3b29964d89180274b4746b4d8a3f415d5c02febf28eae79"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d1eac5abc0f1538a3b29964d89180274b4746b4d8a3f415d5c02febf28eae79"
    sha256 cellar: :any_skip_relocation, sonoma:        "83d1d536a3a01cbbdbfee23b4c7c8ccf6bd5ea57717393d7e6e1b24d98b6e8ee"
    sha256 cellar: :any_skip_relocation, ventura:       "83d1d536a3a01cbbdbfee23b4c7c8ccf6bd5ea57717393d7e6e1b24d98b6e8ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4642423fc1f8f47497adca5fb5ab9ca05e7459a2172b8e1bdf34e10b8d8cd752"
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
    assert_path_exists testpath"foo_1.0.0_amd64.deb"
  end
end