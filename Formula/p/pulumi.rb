class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.192.0",
      revision: "a936f1e0af78844a133e5b21a6f594eace2b95f2"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff61fe7815bd403ae18b7b1b9fd7deb100d8917195d27226ef41163da1eeec01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fa83133cffcea76eb382bd260dd7df1cbc749911c87087ee0fcda6d9a7547f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7d0c8b3547b2224d07c9c083bc004476c07fd2508e7debe5928a29a994084de4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e97656c0a4424306cbaa27ae43682fcae049dd779fdaca8ea86fc631ed376117"
    sha256 cellar: :any_skip_relocation, ventura:       "9de347a0d2d83dbf95ef6eb59d84d0cb0944de8f34f7d2174ac91f824e918c49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "738c499b519df5db2b0914f6815a995f662f177fb0303314ae881ca433c019ae"
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