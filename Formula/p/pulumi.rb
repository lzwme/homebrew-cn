class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.96.2",
      revision: "061d10b4e2b14a36ab9c8b70c36edc19bf94bb30"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "066e5e0e86daae3b78869df686e8114cbc92dfa40ffb673f169706ea2888dea3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a33b015eb010ca6b2876f4528a48417c2b846db61c99d0fb7fa9252a1b952f55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59a2cd8ce4d1287edfc8359d8ff21d2cbdf79a857e08443c90ef627672a59d9f"
    sha256 cellar: :any_skip_relocation, sonoma:         "aea5d142a223e89711fba905bd16e205107aca3a8c13eb8b6d9f55b93ec137c1"
    sha256 cellar: :any_skip_relocation, ventura:        "307cd00d76ab8e2f3ad87b0a246261150f49435df75186cbb3336b65aa45affa"
    sha256 cellar: :any_skip_relocation, monterey:       "94f2fc62ad51ac069bc72a6916a9be8ce092483c24d29b804540ea70ca83410b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "238ff7f821df89c072e7b87761020c9944269ef5ee4da5b4a91d0a5470271fb9"
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