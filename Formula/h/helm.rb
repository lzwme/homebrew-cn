class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https:helm.sh"
  url "https:github.comhelmhelm.git",
      tag:      "v3.15.1",
      revision: "e211f2aa62992bd72586b395de50979e31231829"
  license "Apache-2.0"
  head "https:github.comhelmhelm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0310af42bdf6d78b24cea99b8cde02ae627d9d55985d6f0598467e959465edad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af6dab14f2ca5f7cd796b11541153da3a1d1a2b0161606b405099f3e15f26f33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ab723ed651b85eee7248b66df00fc37c222b2e4624803baa8ab1fa919d0f787"
    sha256 cellar: :any_skip_relocation, sonoma:         "2c654e176c6614f9ee879bcfc5104787871b4a89b6c1c5fc48bb47462f0418ce"
    sha256 cellar: :any_skip_relocation, ventura:        "39a5c34444a409696e4e013de104648a17b20afa81d6008c123e7260877c23f1"
    sha256 cellar: :any_skip_relocation, monterey:       "0270dbd1d256a54a1282a73b272cb11c47a5e8e740493e096fe30203a2ba16aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d291061254e5c5a82f1dfa1d700ae57a1c23e5690dd791b1d8ff72749fcfb62"
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