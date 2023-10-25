class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.90.1",
      revision: "d658f40b125066735866044ae640269b888d90be"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5d1c21fbb301f6a27117bc0180e8de5d5ba50dc4e38caf1a909f7b1b22d4541d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18782a5875fa4385e94f4a3210db29dda30ad6a5e355b5184e42d085ab7488cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01626d08c898f05cfaca94d2ca6616a35574cf5d851790a80ba487b312524c22"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f84098f78d993a891eec3981d4b6ce4154f006975386723656d6c00a9978782"
    sha256 cellar: :any_skip_relocation, ventura:        "5126b56727e9f1d0362588b375dc327fed5f977641c7aad1eb07eb4e8b94ca6f"
    sha256 cellar: :any_skip_relocation, monterey:       "450d6a5092234ccddca909301987635a91851c202f93d876cbe4e20b92347f0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8740bf38055782c2443ad7ae699b4f80a8123087de0fd60fac17966fec6f44e9"
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