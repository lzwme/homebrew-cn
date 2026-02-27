class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.224.0",
      revision: "fe4a3807220cda1acb411c6e770bba8534b653b0"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0622e47d1418c811b64cebffd437fec53977863f432823dee998c776d66781d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e00b7eda56f290a5a42fe3c133083e2d5c1e71ec3d01e75b563422e96d4e1e9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8b1ea7a803f39ff6d20b4d6398248c22b8dcc3f5637c352eac99ca1854e868a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e0335332a598083ff667744ba43e3ea95c7bd9fdf44a27564bc5da65de00691"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc8de21da5b9bfd6a3a6303c5189be3e23078c5e780072a822f4f239827a9f00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00c0a966f5690f4a1cfb1bf35813bb24af3f6addcd75e4809870cadb92a63629"
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