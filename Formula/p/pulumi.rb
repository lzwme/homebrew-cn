class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.82.0",
      revision: "5feb846817bc4947ea3bc802e1c7a452caca35e2"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b652fce599eaf137967892adba1afbc085504c3da6ea5114eeb6ace2a49adf9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62d08e77ce80f434bc11a9d3ed074e0cd46ecf444469645f22be16cf07ebdc41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "060b06c9c58c8952ac75034a8dbd274547e89a11b9e9f93e0e9d39dd3a982d27"
    sha256 cellar: :any_skip_relocation, ventura:        "75d9d42ef86880af7812eae4a5ab32123ec88a124fb86cbd389f1965aa2dad4c"
    sha256 cellar: :any_skip_relocation, monterey:       "297dbd25fad5dc47b756524b249c61f566305a1f8f934dedea965632bd7eb103"
    sha256 cellar: :any_skip_relocation, big_sur:        "168e8a0de0c32635efe5edd0f6728b7ae135fc59b9602966c4aa96f460f28312"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e89ed245365de10051b499ec0a88f2509ee792b8e34fdf0d19602c8ed865f3c"
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