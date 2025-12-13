class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.212.0",
      revision: "35dcb10b7c7dfab6fd30fc5fa79516a462997890"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a96485790eda086115924ddbe3e656638f42156a31866ba1be8b6458254ae3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a718595b5ab782e53bbc6e887b4080f4f793614de495a86115ceacf056923e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00a2da353f658f03525cefa76f14b85b5b1dfbdca9bcfffe7c13e146ae0f7295"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ba7f2f685ecaa2393cf189467da6fe75e333cbe94f163577239467bb5390578"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36b85ea3a1fc7ae77af08629228ca9fe5b720167d7bd785062e240044cb1dcfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39bef29f22053cda0551e9a950e64e66e01fa18c1f0784b7feb3a066c2df4269"
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