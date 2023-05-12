class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.67.0",
      revision: "a48785b24f649d1dae601299a9ac09a8e1f53603"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d70af81d517e0269d7fe54059623129df3a73e3de70d251b97af75d8da77ef05"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09144176c7ecbe4d52921b1ba0a89779a01e53d53d890af69dc48fc8e8d9588e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8dd27390a9b1498b107b0bbe58627278ea97e813d37264c8542f91b659705a5"
    sha256 cellar: :any_skip_relocation, ventura:        "09bec065a96a195f5b0a62d5a2a577bf9b96541ae7448bd98acee2366b99907f"
    sha256 cellar: :any_skip_relocation, monterey:       "41c59aac2bf7cb2a8051172149886a7db0524838ad3fa79b348a97a81ffbe4fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a35f8509b49a135867f2d6fc97190d61a516099a9895fbeac8fcc1d4ae4f925"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48157c0f9e9241d4ed592f48b32a81b3d53d1612ed9e0bcca3892ae887763569"
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