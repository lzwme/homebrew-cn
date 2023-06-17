class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.72.1",
      revision: "c37ada4cc17aca80608f8346640d7cc00f213372"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5b41e3039c01e86a62c887d88a5b9de9cc1f01e906a37f8d57413fb9bde39c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "166d0ce8230dad9280a5f0293ddab2f5c78543e6f30e8990a00ddea0028968dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "754abe1ffcaacca5499284cce9137427b172f88252994336e4593944bca81c1d"
    sha256 cellar: :any_skip_relocation, ventura:        "48384a78dbb36cb5e40438b847530570a66d0cfdcece06f8f442fd585ba4800f"
    sha256 cellar: :any_skip_relocation, monterey:       "26c24d9690dcdc5ffdd60b6a0d1c683417dceea520ddfe73ccad3179e4fa3144"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4a736bc5dbcc955bf8da6cfc13a0ef8b1f4a952eefade98025e962c6bf03d61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49bf3440138a06b1c46291094cfdca41285d12716132f28d877be8ec02648002"
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