class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.221.0",
      revision: "b2f5d688218e948f0c3e024d04c8052ccc6ba28f"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b1ca03fae8c01236a3f50af565fb679461929b80166d9fe98ab08386f0319fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1aa7e37ac1c2b66dcd493df4b4e9e0a81e213f5dc39d85deb077e9c5a6f9c367"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8898cd3b88ecefc163bda29aeadcc2fd95cd2b8840bab3b870c0979f6ec7fb9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "240d5a5c9f8f02788aadd7f0bc10f7f8f170cea4b90ce9d2d39c233e321c1c54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77cf3ebfcf87f4471880eab4f99a89feb8758ca32c692fc952e7cd8471263a5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "130c3e3a011ea443762fb870cdd345f5ddab4b3c29652a8b66f4271d9e1da63a"
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