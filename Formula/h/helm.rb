class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.18.5",
      revision: "b78692c18f0fb38fe5ba4571a674de067a4c53a5"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d8e5787edf0c62d3be84c0a80d966c6ec92cec4c7fa136574338909c5743e98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7890301b698d020e52c44a2455505c16fb0af8d3b93bc5d46b46c6ed8227c7f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b70a98ffd42b9aca0524937b86a76f2fcdbeee189711bc86e2bb3b520d392f50"
    sha256 cellar: :any_skip_relocation, sonoma:        "09a16704d589ef3be89d16982422728167b83b9be25e3f805d12b07b086b93f5"
    sha256 cellar: :any_skip_relocation, ventura:       "1b2a49e40d9f6c3eb5517783efea1227bf566a9980f1d450298c5d3f7af6dac0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d8a6e1d743ed2468323f5c08c05c4dd057dc58b7b72e2c44a386594220906a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "528aa1dc7426c42375726057ff288e062a24860dda3c65e6f91b787c6c52449e"
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