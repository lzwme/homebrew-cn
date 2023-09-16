class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.83.0",
      revision: "e509307b2e46f172a29a6cbb53aea0e23d92f2d9"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe55ea1c5dcbf1d65cba7a059d56e1f0288ea155056fc69ae08091b62a31e0c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fe46bf563fa27e22e3aa83a9bcf4043a7c966852fd306ab5afeba01a8b32c59"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08b0e8759924ed19be54672847b33ae79c57ab0e38654e89c1d458910008f2ee"
    sha256 cellar: :any_skip_relocation, ventura:        "26b47df3c5f8af5b86eec08120bef631b5ffa86d74a21d3e72b804a9d38167c9"
    sha256 cellar: :any_skip_relocation, monterey:       "9a7ba6d499499ef0f399b2f1b99e46554fae12bc8c54a36a104d13fb7e05a0cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "abf3291394b36137f35d81abcb35a8fe673bbc7fd7fbaba60013da4796f55e75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f69b831976a395864e995b94358081d8b9a02eb2e211724ae09a10b41d3f0228"
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