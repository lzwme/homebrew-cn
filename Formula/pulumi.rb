class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.78.0",
      revision: "7e9a02c990178795c59497a81b0053bc10e07448"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0718b851c3bd3afb7a42dfd130c55a8d86ea432d440a0820cf69715980c28993"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "043d518e8e7f2115091d8d2ae9fdc6e8f792868be106f62c490e22d749bfb390"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc47ff26360e92da902b31a2148dad222d8e73e1f32843d6b2c4701f2d013b6a"
    sha256 cellar: :any_skip_relocation, ventura:        "5881b73de9e42045074cd57794528b09e967520914b46decd10fa658073836ce"
    sha256 cellar: :any_skip_relocation, monterey:       "540dac7aa5bc355b4b050301223c6ed307bfb53cc0061081fa4776e0bffebaa5"
    sha256 cellar: :any_skip_relocation, big_sur:        "602c750c8225c96072c57c339db11b621f4115b55664ececbd76275ab38bb6eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1759e400895e70d756bf6056aae87441ddfae5d90747d2f5ce95d15f0311eb65"
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