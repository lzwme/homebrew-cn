class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.90.0",
      revision: "7769e9493d84f87a479b6c9e4e4d586409519b80"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c28733616befda2657b67fc2cb83e7052a51ee7e9249489880abeaaec61a9910"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "224a62ec7fbf186d00fba711a91c97ce3c92e2a7ebd23412f6952c407a08cca6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f664315a6b1aa4a015c4388b69c31bfe2b741bc17bd70b7a4d3cc9dc50b437b"
    sha256 cellar: :any_skip_relocation, sonoma:         "23aae726adb3e702c98b7de7515be04324bd5be8b4f0ce3048cdcb6288f8d805"
    sha256 cellar: :any_skip_relocation, ventura:        "4b1ef2115c4e1b4c88c933bd05af5ebe94bba388330ebb58eb5d4e94c4b0123d"
    sha256 cellar: :any_skip_relocation, monterey:       "7875c5f50c2f11eca806e3945c8793aeb9e119271ea60b5a8e043a3fb7dd143c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d11045ac985c9451e7970426ee089458c05899f1d2c89a87c379b2228263962d"
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