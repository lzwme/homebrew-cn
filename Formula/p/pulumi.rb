class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.84.0",
      revision: "ae0bc5013b5ecba279abc534f37a4398a859248a"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "226ea406eaf5c6ac34d6a7fdca14a80e01c5194967c43d8cfea2e1fef799923b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62c8ead3ae2557ce525135f917255f1e532bf77f4f9cd2dba08c2e970b18de19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a4bf2b27cad4f87f2ded1e8d4ad1c1f8bab3ba8b73a2d0d0c64c82dc75a5178"
    sha256 cellar: :any_skip_relocation, ventura:        "ef48912c38d49c6a88c698c32e8c792b184bb872a293b1973501267ca346a752"
    sha256 cellar: :any_skip_relocation, monterey:       "b211b521fbbc36c7648b25c8ea924c86eeea48c0d6bd3b653c30449b8a2fcf74"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd8ca8d49460a2c7a8eefe870ee1a0f422e439c715e6c0314bf6c7aa216ce110"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eacd0aa78f84d23e1620c0c3958c68c003765429bb7cefd734f262f4b2753005"
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