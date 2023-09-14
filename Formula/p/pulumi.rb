class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.82.1",
      revision: "5e19f606656a3e9a75ed478dd2105d1958d70cd9"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9445232ba36abe1822258c1a6842781520148a51e165f6cb30f19fc70fb6c32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9358c96678161419c7c58d2c45e14a8c4b714d2548bef077af2468b6b5275d20"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "646fc9fef28bce80ed2b2d920e985e605311e2728723033a4989b1b4b78cab37"
    sha256 cellar: :any_skip_relocation, ventura:        "6da8e0d620cfe2509ad28d47846ac29e0ba09373ed52b4ed8641c72ade636bd0"
    sha256 cellar: :any_skip_relocation, monterey:       "7290c46f2d50279bcd52bade13e248002174c59e6e54d5f967cc8e96e1314a23"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d1b0f5ccd606b4d4b1254deea11c2c8510351312316cfe29f2ddb7888fceb9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "077d412ccc1545c7db637e2cd36f1096ad4284fe54f52190ab4d0be4f1728608"
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