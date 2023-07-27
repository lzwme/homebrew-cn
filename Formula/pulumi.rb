class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.76.1",
      revision: "e48af899509b63a7b1de476c67a93e5e5accedb9"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d308189dd5df016fd4028f2cbfb181238f1804b556b1a8262463affd8d90e63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9b86f4948d6d26f5471d19e7ad12f4375dc9dbbfab5fb91d462d55a2de0c1fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45d50a0765ba43a9d863fe6a35e18c0952be85eb88ac0b570d905f87ece2d23d"
    sha256 cellar: :any_skip_relocation, ventura:        "e7b0c80b84eb135996d65e910dad8b41a756e3b4e57e17c8c7d747004a067119"
    sha256 cellar: :any_skip_relocation, monterey:       "7001e110658ecb67ca5714da0765111fa5ea2b916a196117c1d35ec93ee0a1fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "f12ce86d08bd49167f53829a612e92bea56307974a60e162a8b753d49811a5c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "add15bd0967777d702fa1ec5890b6ef17412a84bf4a520a1f04030ba9130fab5"
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