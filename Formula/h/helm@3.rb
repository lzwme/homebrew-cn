class HelmAT3 < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.21.1",
      revision: "c56dd0095fd76da5d7b30ecdf506103e7f26745e"
  license "Apache-2.0"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(3(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "898ab41e046ec6cc856c2a762f9db5bf14ccd9777af7ffdcb835293eb0dca23f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d849efd68df766b2073f61c50566a71751d3b59fec52cd57ea248c577c4999a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fce5752108e03e5bcfd679bab13923e2aff86474ae6b0328b2d17292b2b87336"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2665079e8ff55c2c43b8b9e489b85ccb8ae71df36926c1f217a8eeaaa3b2601"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21925f80e78ba7944a5a9099e20af868807130eaa90b0774c40758ccdf0d3451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec2e1f67e4afc43afb6c76bbf36c1a8a3191f86c25086f1b0cefc41c7e204536"
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