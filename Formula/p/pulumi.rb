class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.194.0",
      revision: "dd720677c64a9dfd5350af43ce6dc7771f3aa60d"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4317768dd6704752e98a19c39ff68a166e5ac39e2b640e4718aadebf2628289"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "940f67dc98955d069a7f57bbef5f1017bb9794656cfc68ae4149a8365b9edd88"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "403353a6b27b5ffcafe273f52307c46b140c49f06da34d4fb3035a229abd408f"
    sha256 cellar: :any_skip_relocation, sonoma:        "499b8a01cb5a660bf18d091fbdacc340174b75bd8f0a1761508965e06d660974"
    sha256 cellar: :any_skip_relocation, ventura:       "e8ae3ae787a7a331418b4d7ce2d8e1c3e7add34b1e399341a5152891ce1f8988"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2509897db04c881a160bb980993eebc9b5b555ea60a728d43c82f7141a2f934b"
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