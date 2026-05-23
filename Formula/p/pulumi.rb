class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.243.0",
      revision: "adffab4571bcac0a3094e895e067afcf06c56f83"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd90693bd12850bccb23a155825dee9dda9aead476911acdafced1268ac31c3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0dbe4e8ed382029728d721d1123c69782d632ab0a341bfe0b9d466c1c246190"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "113b0c4e86e21d6431bbd5cad38d378341e4e855e405726fa49a2d298ca29966"
    sha256 cellar: :any_skip_relocation, sonoma:        "d17f6279f6f25852fc6f1c412199bed7604ab177b5c1afa6630275ec77a5ba5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b759518a8f469ecc77a06f5020fb40c8e94e94999d2d7a8c7705a324f16a03ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c4113826dbc87e5108e0cee3c2a25dc7cd7d765f8a1fbc756435b7dd024b35b"
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
    ENV["PULUMI_HOME"] = testpath
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    assert_match "Your new project is ready to go!",
                 shell_output("#{bin}/pulumi new aws-typescript --generate-only --force --yes")
  end
end