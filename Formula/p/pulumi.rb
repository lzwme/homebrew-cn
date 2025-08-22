class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.191.0",
      revision: "95daff0228925fb9df9d8185928fb0c69f44e6f7"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe8bc2a9f4dd74211d34f190b81dd52ad6868d94899e756230dd2541695197c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38a1ae748031d463fb2e208c5ad9e6fba1d385cfc9411b2323c386a3cc4d59a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7d5f96e32e22d3d88c603a9f58e907ff0de006e940e6d8a1629c12b2f48b98a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c37f0852026dfbd0606175fe890385a08a2800611fe0f3228f4943ce97defac"
    sha256 cellar: :any_skip_relocation, ventura:       "5bd33b3c506fbbd2e31173ee899d699bb84d4785ab0029fc294d118bdd9ff01c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c57092ef047497ccbf30eac2323d6af6b1d5016f20adff9833dd619226dc9367"
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
    assert_match "invalid access token",
                 shell_output("#{bin}/pulumi new aws-typescript --generate-only --force --yes 2>&1", 255)
  end
end