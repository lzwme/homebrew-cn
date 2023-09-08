class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.81.0",
      revision: "b3e4f055bba87c728e15724bffd8fa34c16ce7e8"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "45bf08075a6402a0e1d562413a08fecaa178a046d854ad402a4eb2b55fd94f2d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b78e16ca66fde9cccd4950601f0b2495c2211d961779aebc5cdb7dbf91c0ed7b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "658e7589bf64a758fe01cc42ab4a6adfa406e5909b5fb8293772fe1a29ac2958"
    sha256 cellar: :any_skip_relocation, ventura:        "784fe51918696005dc77389fd497ae8594fedd61f7d4883f79024ad00a3ac4f2"
    sha256 cellar: :any_skip_relocation, monterey:       "b8609ded808bec8165226503a4b4a7969b03321cc28842e9a099b3309b73438d"
    sha256 cellar: :any_skip_relocation, big_sur:        "907b37a67592a6fdef82ca0072ec5bfb1365cb2109f99263027689692c99e9ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea7a789f0b055c35c4e641fd5020a75d4a63ea88b4017e721db9290a41b49a7b"
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