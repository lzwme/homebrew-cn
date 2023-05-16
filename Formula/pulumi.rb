class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.67.1",
      revision: "5037e3a2d75a538ee115cacc2d7a624c312ed45f"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "927fab223404f92efbf5f067d04d3548d62f09d297dc5f0837921843094cf30e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea3f178631e0bf882363343d872e6df3d8895725effc7a4f2fbbeb2443669753"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6bfaf03bb2f9804e43f200be1c9e9d79791237d202885fb96d3682f4322a5e8"
    sha256 cellar: :any_skip_relocation, ventura:        "0c80c6fa26a676f2e6b52d5e799eecac82093b7740b7b1ea1aee41b9369d1257"
    sha256 cellar: :any_skip_relocation, monterey:       "138f780b5ed1c8bb253425121b71fb4e6794445ecb47a4ab62695b857f5c38d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3e99ddcaed6de9ce031413cca0aaa6ddb0b518c002c4fe4871dfa21633accb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a303c391f77b0de19aba9db0bbd0b186d4b799f685dc9fcd348e57d58b25476"
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
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    system "#{bin}/pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end