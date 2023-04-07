class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.62.0",
      revision: "fb96f1db5fb94dfadc8401543df88ea061866520"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68f2d730a4349e789bf129da36f422cd3d6562eab7eb13411d57945c73f83178"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6cd26bb3e1ca271d4857d994a9447debe4631fd12cbd722c1bc6b51ab8505f73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e90fe3962d4ed1b4acc225e07da6b8f51b2cd7f41949bbb94970023166910ce"
    sha256 cellar: :any_skip_relocation, ventura:        "e9c7572fbd7284aa7719ef5d5404dc9800dc7e5b4aa773488247766482f76132"
    sha256 cellar: :any_skip_relocation, monterey:       "c02dd543aa1c25f0559e1a6636d9e3588fb84541ba32650cae0564389a871d10"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5d791fdf528ed4665259f255b45406869c645b36db61bda221184bc1b73b499"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f56e6260f04da64d5e21d1eebc7ffb48b467480b5f09de8fe0777a467df4fd4d"
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