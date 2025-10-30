class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.205.0",
      revision: "f412e2ad2eda71f29874cda807bc76c501df1805"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20f9677205351252de554d1d770ad45775cb0fdc1301579637781281e8a3450c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2f9b8beb02e18861202ffc56ce2e5ee620e9a7f3a3c4fff8ab8443ae73f63ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58ac586a20392561a5c716f2cecec3a31f651b1f5e4194f103349567f980f033"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1e7a3d59842efa72140d843f9ffd130b659551b888607703d2df07e58494c65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "402c86207312c6dd4ea5b393dd2c78282258c5b34c046cb1342e982cea7f7ea7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59b2c6959159792ca7c2c46e698fba9d0d31985ad18f6090d5cad20bbd3f2344"
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