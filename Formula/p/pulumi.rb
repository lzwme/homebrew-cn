class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.217.1",
      revision: "381f23bab07b5cd9437292d7ede7659acc04859a"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50e04a585c5bef921995fe2b47bfa7e4ff920cf3bd5709f4deb3a0e366b71d04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "765fb8d9b8a2a534a3eb09f5e1df2256e40ddb70b24b44f0cf388999b0e7e9b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cdd17961a2d8e92f4c49960d92e2f94aeb18e8ddb3c5a2a2e60b55d441478d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c30fe8b0ffca20e705a028cc10bca34e2305b2fd6585ec20c79eb65d4a8cc03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6928f2b0bfad59ca03343607d1b17bd894aea2d5074e0b5e49f5cd16d665fd87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84dcec0dbc9323f0a16a0aa40cee2302404f35004fab0aecff0f8cf17e42f6a5"
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