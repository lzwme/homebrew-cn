class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.77.0",
      revision: "8ef812d569fc4bb0ec047fafaf0503983fb1188d"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2b88ef356962f968ef3c73d6d7f7517e317f531eca27ee108792320d7715273"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a37a3a3972b343d0b34bb2dc99be6730ae7084b4e9716877c12f55ce8785b407"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d2eadd133e70233764681ad34b312b3d2acb063b01589973def1575f0f00c88"
    sha256 cellar: :any_skip_relocation, ventura:        "62073535a589fdc03537b26deec26b5df56f57d69b9e444848d6739ccf6ceb5e"
    sha256 cellar: :any_skip_relocation, monterey:       "33f59f480d71bd38ca6ae6bf4b7d064dbec5faca4cd39daec8d1d926e729bb47"
    sha256 cellar: :any_skip_relocation, big_sur:        "e99c189b911109e5ad732adca39140018e9e4a1a5348795a683cbf0fc2444aa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a875795486b31c7ee950f99994e983dd48910124dacc3fda4feead10ff8e0b5d"
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