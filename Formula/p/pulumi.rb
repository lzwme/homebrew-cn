class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.188.0",
      revision: "af519ef0b955d6ef424c75d13285218d75ad8eab"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0799cd63a5d1eb8cc29c36e62e13ad685bd9e3520820cb2318bc3cb1d7490ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fff330416ad3da45e1973955c180110f6d7514ee7f25ac23c868a8526b95bb2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e8e21b232913ab2872363e0430d0501772e20cdc60cb4027aac7a757b5f5e7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "154e1c6cf603ebfa812793338204d8eac9910b684c57b74fb741b88f4883dba0"
    sha256 cellar: :any_skip_relocation, ventura:       "50a7526fab01655904b31ead448f29f1ad1b854706b27fcd714930d46bb4d1d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af37925dc2095305066f640b515395500a48186b919fcdf01b692bf87872fa3c"
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