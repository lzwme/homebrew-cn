class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.204.0",
      revision: "24654399abdfe5725bead8d54ad64efb554f6392"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25b1d00843647510557a264826f839ac3a1038bedc9aabbcd92f18e8699af297"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5c44f223ed0d67a3ae17647cb9d44f5372be1e1a4d25803140f78aa990a1f0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af7eaed3ccb141eecfbab4c996a6e5bf9fcbdc637e86f77a9bbf899ba48d649b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f44e1f35e3817c6442b5086d130be424fc731d359cedbdf2da6a94958059bb7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e48189b3e5425fd582532c72931cb609049aa6cf671ca218a7a15f9f0a6f27dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66bae9415e993f8efab0876cc64d1b387b7d9b0c424e3c0186d5df7bd4b1bbd7"
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