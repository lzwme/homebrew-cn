class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v4.1.0",
      revision: "4553a0a96e5205595079b6757236cc6f969ed1b9"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05981dc33127f66a4977dbeb3f38a63a8230f50cb161379c153a72fbfb494c1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ed5785bdefd1f334793fd9ee0a1369b01f66b6036730810b84537fd70df0e64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24b55043028fbce06a4f3f8a9b617641618df0a686c7e7c35ebcf8364aee9410"
    sha256 cellar: :any_skip_relocation, sonoma:        "dde056062533fa42551c8b119557d8d12842ba20db2bed5f97995e3fd7ea0eae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79bc122fa5f30bc852908491f71243fba42dfc7555a275df9b18e34225229d43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "269ba1ce3ac000b3e27f6f9801b553439182591c9e8c9b6612330a6f67d8e728"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "bin/helm"

    mkdir "man1" do
      system bin/"helm", "docs", "--type", "man"
      man1.install Dir["*"]
    end

    generate_completions_from_executable(bin/"helm", shell_parameter_format: :cobra)
  end

  test do
    system bin/"helm", "create", "foo"
    assert File.directory? testpath/"foo/charts"

    version_output = shell_output("#{bin}/helm version 2>&1")
    assert_match "GitCommit:\"#{stable.specs[:revision]}\"", version_output
    assert_match "Version:\"v#{version}\"", version_output
  end
end