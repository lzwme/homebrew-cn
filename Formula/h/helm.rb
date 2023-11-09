class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.13.2",
      revision: "2a2fb3b98829f1e0be6fb18af2f6599e0f4e8243"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc28f0be4383697ab3ba36579b6906aaeca8bf8bffc3efe36377920e8ed2edcc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6637058834daadc414801e19e5155d42602a5d7abbd4e6a845cc888b4f010e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d097a52e5ec0b79a8268417f5fd3eafebe1ca6253d2a854bd20f2ff084d9f59f"
    sha256 cellar: :any_skip_relocation, sonoma:         "1db03d20541458898d28df3a76160396ea3dbbe0e031cc4e63050a81030a7127"
    sha256 cellar: :any_skip_relocation, ventura:        "c6d27896985706bb3b3f6ffec77ed0ca57552a02d98211c68a4abf6c7a9c3e3d"
    sha256 cellar: :any_skip_relocation, monterey:       "2198e4a5deb0536f04253acf41301fccb40208a8c45c50ae7264d0cf3cac2244"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8902b02a934316fad4d684a57d382009dd55003a81c9bad6a82bbc18e1033dbc"
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