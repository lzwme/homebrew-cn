class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.225.0",
      revision: "ca6228e034a1d0f01e1a49cf13ab16551382d60e"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8786da85ea36ef48439d3806b52a298a260e70cc6d2d15b8f663719fc1e838db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18d9169be7f66cf3a5bed1291797482bf16b69bf8297ce7ac3b41656881947a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9790cfa04385362fcafa5ba1dd28400c5cdfe799b9cb75555df2b6dea7b3d07"
    sha256 cellar: :any_skip_relocation, sonoma:        "143380173079846fc43d934c03705c5d8e700303ad55eb42e520a6a6871bb150"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84b732c079d2079957ba32b607138f04b3203036d697f0cf6cd525c39eee5557"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46d833d1f97e1fb8821dad11926d14f05c66a8fadcc7fcfa99be160533065c2a"
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