class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https:helm.sh"
  url "https:github.comhelmhelm.git",
      tag:      "v3.15.0",
      revision: "c4e37b39dbb341cb3f716220df9f9d306d123a58"
  license "Apache-2.0"
  head "https:github.comhelmhelm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d5304df58b1000425c6191511e7613e6fd8530fb1af120b3a7c18676a47a6711"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2868278b24bb87088f4eb6de8f4543fbb23c8c063cc88bc96244f18b33c46605"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6e1a273276e291d68cb4e2fc0fccd055045e4dcb0bf6d30e17e58c1a9835b3e"
    sha256 cellar: :any_skip_relocation, sonoma:         "7048305b88a01d62b7c25727263609facdc89492789674a59dda77f7dc9d058d"
    sha256 cellar: :any_skip_relocation, ventura:        "ae6cb79882b6195eeea4f08419a0d4c07ed03135f26c2ab5aa16867ccc4fcf68"
    sha256 cellar: :any_skip_relocation, monterey:       "da15235a82bf6a08e2f1d41c21311e8eb70441c1cea2ea51b3656e07bc9a61e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b42ffeb9d72f8c149ea2b5b52a9a2e487f6e433ac5bff931cc578f2e98d8a35e"
  end

  depends_on "go" => :build

  def install
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