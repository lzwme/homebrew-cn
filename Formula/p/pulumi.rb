class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.86.0",
      revision: "2b44cf6ec1be6cc62a2648daadb0222f9faa0de9"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9658459db81e16d50d1ca614d958abe8313c03d74777a36eebd0e61a4950fca6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7a6cd03e9a8e60740449b19aa0bbb39711c81f64bd23f882407c98f617276af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15f5a4dfd3ac0ad6fa3556a9134e61bc3829d11c97ecaa05011f0247fb65733c"
    sha256 cellar: :any_skip_relocation, sonoma:         "41f2512e19fb39a5ead57e924486f28b39d3ffca97f02cc6b50b0380b572f361"
    sha256 cellar: :any_skip_relocation, ventura:        "06948be5ebf26fad254c2053dd6f3b0b36e688cffd7ece75c04975fff8b0b790"
    sha256 cellar: :any_skip_relocation, monterey:       "bc72f6e83c543d9973b03d97ab27d3c65b572c6e11e6ab1c9b3852ffc13c6929"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e59a9b4c967d55d74d136b4ae36e0c05949d6370a335c42169008281de453fc3"
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