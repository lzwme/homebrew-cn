class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.75.0",
      revision: "8731e061ffaf938a78ef0ef8a440a6cf4395b54a"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "797f55866d20fe7c9be6ea634476397802b274f0b377c3e6670186e791bf189d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "018d133c22b156a31092d4d06df7aa6314d1defc0ee51dcc280dd9ecb8b7e048"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8223b8aae175292de51663698901f7c7cb7125b5ed784083c8e17df270fc4134"
    sha256 cellar: :any_skip_relocation, ventura:        "95c005c98b2f00c6933c9ec3a593c04dd4cfad4091deab00980066a093f1b2b9"
    sha256 cellar: :any_skip_relocation, monterey:       "a48fa92a2eea97b62ef6afb58bf5fa504d336f34ba6eb91dc9088a50a8651a6e"
    sha256 cellar: :any_skip_relocation, big_sur:        "108ef6287462f7ee9f61a9f54458f17dc1177dab220a12b971d4b8b94971776a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb9b3d59cf701820dc05459012b6a5bb6a338bba366ce8cad00f5d49aa843af1"
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