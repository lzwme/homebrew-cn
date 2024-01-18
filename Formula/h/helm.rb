class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https:helm.sh"
  url "https:github.comhelmhelm.git",
      tag:      "v3.14.0",
      revision: "3fc9f4b2638e76f26739cd77c7017139be81d0ea"
  license "Apache-2.0"
  head "https:github.comhelmhelm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a473b31064afd43207e46fd21e4137565002e07d6da44ecdf9b3472585e1376"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b0354ed747500143222b256f4b3f58f5fdfbee8c890ebdaa0fcc682eb9e4903"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0785546ff2265e8a75825a52e819eed847be3207fe724e0026c3647af6c9838"
    sha256 cellar: :any_skip_relocation, sonoma:         "13ad627d4de54b7a91f0ef20bdff0522288003e1752b4ac739304958c30715d1"
    sha256 cellar: :any_skip_relocation, ventura:        "1364d94ed02848b1a99769ab03a82363ea0d19a9e612245b258f38e764fcb676"
    sha256 cellar: :any_skip_relocation, monterey:       "d3ab5a471654f841bcd46f3b89e57001e1eefb153e6c98c165dc8fcffaba981a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bce4cf5ab98685cd4e4e4ae2627a969b008778106c9214504e71bf962193d53c"
  end

  depends_on "go" => :build

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"

    system "make", "build"
    bin.install "binhelm"

    mkdir "man1" do
      system bin"helm", "docs", "--type", "man"
      man1.install Dir["*"]
    end

    generate_completions_from_executable(bin"helm", "completion")
  end

  test do
    system bin"helm", "create", "foo"
    assert File.directory? testpath"foocharts"

    version_output = shell_output(bin"helm version 2>&1")
    assert_match "GitTreeState:\"clean\"", version_output
    if build.stable?
      revision = stable.specs[:revision]
      assert_match "GitCommit:\"#{revision}\"", version_output
      assert_match "Version:\"v#{version}\"", version_output
    end
  end
end