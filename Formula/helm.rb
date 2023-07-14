class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.12.2",
      revision: "1e210a2c8cc5117d1055bfaa5d40f51bbc2e345e"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a29353a4fe1db28a4fa6e59e27f9e8341ca5fb9d945f045aed2f533a4d5b1e9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aec37584a990f22aac9dddfd0e8226769135618c2600d3e88f837cafd3761ee4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6048befc9c16a155c15b7f8984907654838cfb367d746e129cf206def46c6aa5"
    sha256 cellar: :any_skip_relocation, ventura:        "e270032a0cfb27547f3bbe2c1980857357bf6059c7666bff2e4348ede10bbae4"
    sha256 cellar: :any_skip_relocation, monterey:       "2f60e78d0890480707cb9b1acf6e758443a27a47ddd4e21f42b3a42d4a2f03e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "482ce8228a070ebfbc02686e89689a59ec63b85ada3d64a609370020922855d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c47330fffebf847ae9d66f081ed7279f33bc9005c884ff659090347fadccb3fd"
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