class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.214.1",
      revision: "3186ab67b16ec125051c6eeb96817ae96a7111e8"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab8dd7bfe149e2c52667c1f5c0a2629cb8a57fec12c0ec6f2fa54fc7345648b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88a36877eda6640a491677e7ae86c8f3c170df5ef20a19f11e470827ccdf915f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad94f97368115dda8d012a017139be4d195bfe5e466698fff42be0765892ff80"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d31eff810ee545c82a6cbed26ac23e877709a3348063eecf5cf7e5fc7aef5e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f49169ca94dfda83513ad8c9c27b411e78d083ce42963996e8842cbd205aacc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68b421b1316818691d543603fda970e0447b4e607bc67e7f5619e9599f9b3cc2"
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