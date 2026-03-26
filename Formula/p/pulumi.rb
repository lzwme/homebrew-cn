class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.228.0",
      revision: "7551b7f72e4cd14769cb708c528bff771c0f6f5a"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd2e9857193fd5e594579ed959c0a3e2cea13ee23899db7e4b1b36dd6ab15bac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2047ccd251cb588f3cff87d63edc46150f8150af14779fe5d1f0a6c62a810f87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34ff81c955fbbd610e8acc6c2854e8d5feedf605c28b04f4987ab803d0120022"
    sha256 cellar: :any_skip_relocation, sonoma:        "f82e3b0eddede5666a28b223a86de8d11d72364c382ab1905fd647723fb66a5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4916179bdd9d42fa8e9724340768692576c4be5123315ce015ab6c37d6bea34d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb2e139db2add6776b89e2daadd785c66b7f3f134c97cf931cad49e29188a445"
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