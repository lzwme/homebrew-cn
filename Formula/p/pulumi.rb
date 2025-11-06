class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.206.0",
      revision: "72334612d3d61c8759c42c2312bc00a3552e3cc2"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94952729e04746334b9f2b59a678f4ff5ec43e66f315b06b8b6ad73af5458dbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "400c33b316ef66459ee7bc93f843c7998cb15b5d46901be4035a402c637d66db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61183a5b62c7f4048c576afc92b24d0fe3ed1515deb55e2832790a11eb28ec98"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f8bc1beab9e905f2aec66a133c40881c8dd98938878789d5af5f28488e4b723"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6a9af95b7b496fd36084da76dbccc8fd184a6ee0a64e4f2c72f94fc2836a9fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0a620067260b044114926f0c4fac89d0bb7f2020cc33b21074523c060d9fe5d"
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