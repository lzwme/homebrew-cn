class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.223.0",
      revision: "fcb59a8e248484e9584927910cd3429fe138bf41"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc9c8dbf5001a873457ac14dee266c01a53f26794a91cc5ad6f1d62e5e6c8cca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "100160f1cdb247a897100f4469930ae5f1d792e706f01638205f3a3764a4a584"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f9a7e0d44cefae4de8c7e37e3843f0dcde2352dfd50c99d1bb1582960c10d62"
    sha256 cellar: :any_skip_relocation, sonoma:        "a28d1a538f8829da9274935b6d77657117663b91e2aa9abbdc489916f992c2ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29c88f3b97f41dfd4085cb4989526a15feebc73fe1652a1021b7527f1d8671fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25a122f0ad4c896875e22de23e0424aed10cdfc974a3104399b3bcc3c088c609"
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