class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.92.0",
      revision: "ac6adb98bf2c3f0319d72df6bed00d24a3758ed2"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "01750ebcc6eed50cf924810233a6ed1c7d3648085d54d6e923183c1895684964"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa0a861a6d74671ba12b5f57dd4dc6480a4af43d8f07bb3c4f7df07e1855e116"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a3bffb025f040e81ad492ae7ebf438eecbc3138c315c81e43e8036dc9ba05f7"
    sha256 cellar: :any_skip_relocation, sonoma:         "ceb315f0c80754c243e811562fa998f64a18f28d968e50d1f2d497f0d802b18b"
    sha256 cellar: :any_skip_relocation, ventura:        "ae0e90189092f3d323407f494eb5a99dff2a857368414d2f62c69ca48657a3fa"
    sha256 cellar: :any_skip_relocation, monterey:       "4d173ebff6bdbff54a29e4f8267aaf05e00b498a1b3081190b0df29f66b0ff64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab43aed4367c018866de562c72346c5cb9b2afae24763a97b422bc2b2eda0b65"
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