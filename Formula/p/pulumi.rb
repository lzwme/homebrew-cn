class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.94.2",
      revision: "55764eb6208e24b04d1d738e2df97e2ed774e6d0"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3c124d170254cb63711e957422c985e1300ac30ae88499fb3e0c10be39a47f71"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be5fa348378f898120bc9959769d9dd3ef6a5014079fa6cc62c82b38401ffebf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27059bdb97367640f372d5f414470c71f79d7062da000917a3612fb58937f8c2"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a2b800bd8d1519bd606535f3efd240c3d8beba69c84adf86cf1fe91cbd85e30"
    sha256 cellar: :any_skip_relocation, ventura:        "7c560f34e4eaf519466261349fd11e09cb9086f36a3644abd3140a888d4160c4"
    sha256 cellar: :any_skip_relocation, monterey:       "ea7b17d94a4cdfd0c4242037f784c6348fc2081e781673e68c8a7aa16fc4c67c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d8828d1f08c1f78fad2e2ad23a01f7da8d2e16838685c1ffbb37748f7190835"
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