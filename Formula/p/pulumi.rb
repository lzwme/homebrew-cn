class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.202.0",
      revision: "fe6df4b93c96bd35b0bc12a3bcbbcf30134c5c16"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a6fe397e709257aac29dc2e0cf041f667f8f4b50738c1d57b2b2c4ff9a25c82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8f2a3e080b077442e7dc6956284a42894b43dfc91d9de4f0b23e2349be70c5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3019ec0684b6bc09b886ed5af24bf65017584f39647795bf640af5482b6825f"
    sha256 cellar: :any_skip_relocation, sonoma:        "04130ec553edf6d6ff9b216ac65d3f225b0e1df314be56a83df5ec512452490b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f8ecf4ad8e6ac40f2623c1ebc688ed0a7a5a260bf4bad92cf550f77e5914377"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2cfadb4f24bf23cede96ae2d4803948830ecdfa0a2398a8aad92e79769ed88f"
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