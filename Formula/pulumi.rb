class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.77.1",
      revision: "503747ff6fdddd01c8f30452fb17729b943f490b"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46df560311191a272875956df4c91811af792bca392175ac5415feadeb17d4e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c30b1b216fb9dc803f591e8549de0a2cc4f6ebce3b63249e023eafc1c790a54"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "50738ee97edc65e46513f06613b12400f2ddfd498b5170dbb3ef6e370bc30f53"
    sha256 cellar: :any_skip_relocation, ventura:        "d7e77513a25042190f1c08f84c068e91df115b339a808f170e5df6c4e5cb7b8c"
    sha256 cellar: :any_skip_relocation, monterey:       "299f24441851b808205e41137d4f8fd1bf0dd4ca7f0c143716175cf4c8e1a2e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "db7b25c8db7e3922530c6f7345dde3b4232027ca03fa89aa5f9e194777e3e902"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d996a93f73e4b960ec03b0cf843b29d507860a0d61d3a385e595b0f33eb03b0"
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