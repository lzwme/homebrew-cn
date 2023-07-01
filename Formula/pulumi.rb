class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.74.0",
      revision: "a4350f866a06a3129d3616d6734a14496d76e2ab"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67f84ee5721481c76c3f58fa02f41a7bc46c7cd9329573d0bb8f0f8b1d62b62a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87590d8035adc44fd862d8a4bc1193a82d3d554aa762f32bddd1743ae0d15a3d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c5873c518bb3ea044a8743145556449dd375e7a9f88b27977eddbce86a97fae"
    sha256 cellar: :any_skip_relocation, ventura:        "f0237436d4a0fe35a4603659d512eaf3f46943e225f1573b66fbd04e3e89e799"
    sha256 cellar: :any_skip_relocation, monterey:       "e813da6793c7b7207665cf8298f236728312a2de66c56858b582a607fb2bb418"
    sha256 cellar: :any_skip_relocation, big_sur:        "884af4727f532f1e1ca3232d282da74b8fc7b4ed80c7fc76f71b7f8bac7a6e80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13dbd7777e7f67770b1857cd4a05e0b71a4efa5b5d9db5b538c0505c6779df8c"
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