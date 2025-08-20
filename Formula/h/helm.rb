class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.18.6",
      revision: "b76a950f6835474e0906b96c9ec68a2eff3a6430"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "594f288d1a97cdeb51a16c95ce6bef5a95f71a93713e6e976dfe8d2c3aaa1fbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "595f451d10a5b493d8f61a168c6de3b75812c87ac9d0556852f9ae72282cdc1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e24caab2db879d259ea13f33bd7dcc865a5780a8509072423d3c22c8d2b33bb2"
    sha256 cellar: :any_skip_relocation, sonoma:        "557d218bd6c9ac4209a3773bc9f51f0aadd82c2a02d2f9b1aa535badc820b117"
    sha256 cellar: :any_skip_relocation, ventura:       "cdd3bf80d011e5bd3743497e77f3a55d6aec378d17c2dbdbf6ba4c5a06a8c9ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08fcd85c641ec33a40063b8261e197b246129c6aef23c91f3dbd9cdf14cb2ad3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f16f8487de18e2601c372197ef0fe9783f6e762f55e423f76307db17378e076"
  end

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