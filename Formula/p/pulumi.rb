class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.79.0",
      revision: "1a1d02fe8e7f546e960436188991206fd6729a18"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33e0f9734d12aab738883644918513fa40190eab499ab23fcb1281649369a558"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4a0990181ca70e79f080ac37c11ae3038cfe786b70f033cb2ec1839aef93271"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "632b153b6bcdddf20ab639ab11601c563db7f99b53fb3336914251f42fe2316f"
    sha256 cellar: :any_skip_relocation, ventura:        "fc959ff8e3da4414d8d2bc27063bc2210e9fecffca8238c8797f96aca2e3d5b7"
    sha256 cellar: :any_skip_relocation, monterey:       "383816f0589876acea121632c26e6acac858f92848032bf27eacf669dece949e"
    sha256 cellar: :any_skip_relocation, big_sur:        "4fb56d9062f83fc12c5c45f2df6625646f605e03118b93b4c0597e7cb2c24e0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5824e45dd792f4580fdd7d378a142e9e0adb522af8a616c99e45bf5a3b8f277d"
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