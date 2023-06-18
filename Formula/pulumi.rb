class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.72.2",
      revision: "70207e899edd186bd2c24b918babc42151020d2b"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7983d743add331e48afc1f18ccc237e8e8a31aaa2166ab163ca31d89a0b7d969"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da38e5613112c19f0b04df2fb6b28901784cabd795bd537b254147b902a3bf78"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "960289af81e2cc193f70f5cc0847c5e687b4328d640ecc3901fc6b73423e1ab2"
    sha256 cellar: :any_skip_relocation, ventura:        "a8d62e96eeb9b2c42e616109a3d4fc55a9218f699e548e6efa8164502f7afe67"
    sha256 cellar: :any_skip_relocation, monterey:       "6541a991fb7c0534e5f5f5ebaa9842fe7dfae266f5e5f185e4f3273a5b1a62b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1d8f945bfe566a977b91a98071ed1b1176eac2f67ed9313edd7f04368d5b783"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8a2b08edbbea338581c45b538206953c63baf51378c941890688c97166b42d4"
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