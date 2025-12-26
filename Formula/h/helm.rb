class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v4.0.4",
      revision: "8650e1dad9e6ae38b41f60b712af9218a0d8cc11"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ac7fe8736fc1db9a388cdee6835e44bf05105d037762329fa1729447d1c86dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "208abe5b28e84d3da8b7b645264d059f8822cf7b5eadb88ba396cb9e4b4e5141"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63f10b723fbf7b40c3d9eae25ad1319418736deb6eeab4724ca0599f259b614d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a73a4f4cad4b79ad8a4fb46e79ba5f9a6275f8af75964dd5985e389e77682aa8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4537235619bdc0947e725088fb15e30ea528c20d0d39b50269bfa6a53d319d12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d33f65f7acb5e8ba34c74b8cb93ef41da363eb8b145d8cc58b4b5d627e367437"
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