class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.11.1",
      revision: "293b50c65d4d56187cd4e2f390f0ada46b4c4737"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "989eda1150577f14ed52d159bbcca7be9df193548141570ced02f39d774c7acb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b94f146bf5c9a337fdbe23814d8bd619576e9fe8122b75e87b52af66eab0442"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b3a588ef91725ed1382a2d5a50b84ff4a55e86b020de6d62d35be5c3f62638d"
    sha256 cellar: :any_skip_relocation, ventura:        "7389b0f28bbc0360955fd18aff1854b9ab336547746845de8dad49441d3b17df"
    sha256 cellar: :any_skip_relocation, monterey:       "c523000930a9d16da7305aa485566598e19238cacd414ae91d8ce14abc529624"
    sha256 cellar: :any_skip_relocation, big_sur:        "0fd55830145a15ea352733df764c3fed2cfce74d91c48d690266194507333864"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fff596c76ac6804524ae15d6072970dc35a26c70d07d93b885993470937558e2"
  end

  depends_on "go" => :build

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"

    system "make", "build"
    bin.install "bin/helm"

    mkdir "man1" do
      system bin/"helm", "docs", "--type", "man"
      man1.install Dir["*"]
    end

    generate_completions_from_executable(bin/"helm", "completion")
  end

  test do
    system bin/"helm", "create", "foo"
    assert File.directory? testpath/"foo/charts"

    version_output = shell_output(bin/"helm version 2>&1")
    assert_match "GitTreeState:\"clean\"", version_output
    if build.stable?
      revision = stable.specs[:revision]
      assert_match "GitCommit:\"#{revision}\"", version_output
      assert_match "Version:\"v#{version}\"", version_output
    end
  end
end