class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.237.0",
      revision: "dc35aff8263f8fcd61bf93e48937a14eda6aecc7"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb8a5254b384f244d9bfe9f3adb19418562075dcd40a1ca205c181d60c015bb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56912b71e44fd8a2a1382d51d7c8c094634e3640164bebd608e65970c41aa4c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a717429d28d9748dd27d5a9505264f47a5f586f46bbade863ce2d59b37077c0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9895fc0aab56c2ce15e9fcbc28648c162f9a8243ae2c3f6f6c1aeaa215e282b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22438b4529e8c5e391f3ecafa372812ac80e85734985d48f8aeca470bbcf90fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e253cf4873f47602d29a76acdd1a697c88cb74698af1ddbaadb38e98e282e93"
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