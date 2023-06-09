class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.70.0",
      revision: "dd2444838aef4b6b53361df007969fb4c83cce91"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9cf51d43a7b27d6d01670182251b5e897989b9e5aedab5e2a7b220e86853410d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be3714dbd8d0233e28796228d8e0a6708dd55797cdd551c7017e80979de74d7a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "799c33ae80ddc9ef6007a23675c9d2d40a3c3a20b04d0a898fff2d16e3d52c6d"
    sha256 cellar: :any_skip_relocation, ventura:        "0f3aeed7e048ad147e291eed5a65c300b442e8f53b1075f7f7887ff6c816a055"
    sha256 cellar: :any_skip_relocation, monterey:       "57d38f68b7290bd55fb78ffc098064f10e2f922b0877afe43efe75ff32ad3474"
    sha256 cellar: :any_skip_relocation, big_sur:        "c020541771e15e1a7ebab31e6bfc1ac7cc1d40ec8f6ddb3f1ceee57b311a77b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78dfee7bf74cf6f0120ff943d59d68d058a4a6dd25bad6b0650f5182926e0f74"
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