class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.250.0",
      revision: "7549635909277a54490acc87186590b816762fd5"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4fa290aab3247ab360dd7d4ad54c69399481bbecf5a5cfd0428284495d0455f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdbba109fc8d13cfb38b4c946c75fc88ed30db046d83c3cd4ed2f9173bb74994"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4aabc03d4d6ad7dceedcdd86dd1e1b563416a3b9bec4085e5b7cdff897b62e18"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1f3b75647e8ba5bdd4d977f726c775e6f18359b0463fc23a78a88587fba56eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "331bd8018927ff27bd51847c9ae9176fbfef359942c3cc1b22bba768c3386839"
    sha256 cellar: :any,                 x86_64_linux:  "64501491651be873eb5e7cb629b43866003549cd8dd240e8c8ca406368175eed"
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