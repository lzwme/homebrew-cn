class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.210.0",
      revision: "43bb5ff53cdea5c32ecfd4788a6e9ecae6f5055e"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9101df4c3b21a014c263b39ce5147a627430fbcd4e9eb116db5aa86e117906df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba4bb4e1316c4abfffad2e8e36997f05c0128f48968e02f668ea51a1ddfb9757"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0452f643b2e49be482f641adb1145d74e723d108a7a1aa5587810feea2e84c2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4b61632283f3a6daef9d92af2b7b588de2cf7086a12df43f9e0f1d25e4871cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6201e75713500eb27056ea78300223c82d0d40bfee426a956e56068d6ab47bd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88002cfc00c3dda88aa1c14306c1c9e17f7f450ce43edb8ce40fe6890a36419f"
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