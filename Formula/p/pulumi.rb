class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.199.0",
      revision: "2b1ed7f281b494287a1fc599f3e46e32837f4d14"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "edf82e3c9419368036877319119c7da95b352283d54431d1022f1a4ee743c1e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44b9cd64749ca6e9d8be48d00d59319c5d65d6200ae894ea9fe7ff6aba9a2b10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37a19e440cef2eae2e5c99eeb92ba7d6a9264680925755d1d0be5d56af84dea2"
    sha256 cellar: :any_skip_relocation, sonoma:        "01095b35f9db0808d1f81aa1bbf3b2dbc2791619d7fdcaa5d36c7dec08d7b244"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd72da56216c596c17aff88c8b5bd31c853fab48ca6d2349d8d0ec747ed8c567"
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