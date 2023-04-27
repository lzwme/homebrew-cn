class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.65.0",
      revision: "35c7f566c63cf1bc9b8c4d8b6035049fedc7e19a"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a0d56c8ae9b314cb2e03c04a9da28301ea6d8d95b985dfc641a458c27f83dd4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6e45efd1509ed5561988569ceff10f4de4be14c86089c82d13bc97c01f1e9ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc1358a25f1f274d6d322ec090b5c9e93286e9c87c1cf300ef56a48e082307dd"
    sha256 cellar: :any_skip_relocation, ventura:        "01677bd63ae7e265fadd017e7ba36ff64483b0773135bf2295d3d32b5852acc0"
    sha256 cellar: :any_skip_relocation, monterey:       "ffc7fa5e80e7a5618ed8b93f5b7c158989ae6829f6ef871e26a5613352b674e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "3238ca9f5d63a2159d48eec2d3bbcbc6515cd642abf4f710acf43533ea55b20c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2bce891b2fba1b107c6d6455684faaecbd71c8a64f9fc0cf7bcde627a8f75de"
  end

  depends_on "go" => :build

  def install
    cd "./sdk" do
      system "go", "mod", "download"
    end
    cd "./pkg" do
      system "go", "mod", "download"
    end

    system "make", "brew"

    bin.install Dir["#{ENV["GOPATH"]}/bin/pulumi*"]

    # Install shell completions
    generate_completions_from_executable(bin/"pulumi", "gen-completion")
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    system "#{bin}/pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end