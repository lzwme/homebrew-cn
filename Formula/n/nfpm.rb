class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https:nfpm.goreleaser.com"
  url "https:github.comgoreleasernfpmarchiverefstagsv2.38.0.tar.gz"
  sha256 "2978338f442fbad59da8edd27512f1248226efc99dd8bac5c9ab7f3bd828c571"
  license "MIT"
  head "https:github.comgoreleasernfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8970d4229bebc1fb43737f5b1c1cce743d50330c5587dc9260b19e689d1d0b99"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "835b5ee2d8daf4b8b1bb91d6774555196a1559901ffd61a2ee3b4b8c58ee4342"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c0fe7d5c830897084a3513f877dcf957254a95da50842267e4512ec4e261982"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b0ba2007feb5f29798879df379c72ee889c0c102e48967b6adf36bca5f67f8a"
    sha256 cellar: :any_skip_relocation, ventura:        "4e79d7ac2e818c949eefa4ebe431a0b701c16346480c2787d8c585e390985e0f"
    sha256 cellar: :any_skip_relocation, monterey:       "22e8d57472c9fd4182a89bbb0739101ec73ac5b189d5a892042ada6a0857cad7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72e096143f62499896f1ad9b538864fc881a9b7d458607b565407e1e7f9e0c94"
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