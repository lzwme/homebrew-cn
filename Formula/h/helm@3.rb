class HelmAT3 < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.19.4",
      revision: "7cfb6e486dac026202556836bb910c37d847793e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(3(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25d677f8f7f6e9f85eb28731e4867a97ea4b0caaecd0d0865d0fbaa487a14d6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bed5bbb491dd681da80167a5bf297c00e2a1ac6c26fd1d6d779d98d3099d0e2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30958601a6af163669b3a09e6dc6c7c33aea9934c0402c0cae443bb737581d07"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f4dcf4620cf4e3108f0334951723449b05e568f39cf93f745486407eb5a451e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1dbfa29938f8c918f92f2e314f9d63c2f7d96711cf35766188b045037efc6e58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63c48822a162ed663d876da6abbca128323d5242663183e56a315ac6cd432a2d"
  end

  keg_only :versioned_formula

  depends_on "go" => :build

  def install
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

    version_output = shell_output("#{bin}/helm version 2>&1")
    assert_match "GitCommit:\"#{stable.specs[:revision]}\"", version_output
    assert_match "Version:\"v#{version}\"", version_output
  end
end