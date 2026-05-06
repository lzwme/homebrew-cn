class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.235.0",
      revision: "646bac6a8e0715ae616339ff4446fadf458639ca"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28b05c698249b733135bda9828ce829ee5f36fb332e855baf0ae2ec991ca5d0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7467d886206b37a80aeb973a61bad94ac70d90eb957a871a5685b243511475d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d003fef2dba1ed65901d2ab75a2d5e9475f5747bfcc7e400082d64feed2f968a"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb6b07a90e68577f93e8b482b40af05f8a692c189a48c8c74d7e3cda0449825a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88d41cd8904ecb8a09be877d4cfdc3bf62f4e260ae042db6e444d7ae49f77877"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "565b1db0a2fd800f81fb21687c22ee0063d498659ab3c288e78d3a38e6828abc"
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