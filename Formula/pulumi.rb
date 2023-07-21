class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.76.0",
      revision: "f23305a76527a5a18dd66ca6d1ac7d5e7badcbdd"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35b14c7705795ae7ce2ea563ba8453664f253444caa52b629ac605ad95016eb8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "391c48001633737d6d5ab7a828e2df974bf5bc7401ba30f7a061e453800a51a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c74dc34075c2f7845161f3226ecefbcd7cdcbe38a50665ea15c9cfe0023c75a1"
    sha256 cellar: :any_skip_relocation, ventura:        "3b361b1714d1821673c860ed772ae7ec3a0a0cbcdf68b253d713009638bf7eca"
    sha256 cellar: :any_skip_relocation, monterey:       "e4b74e396015366bc4562fa489b0ae211bb20059b95ab5372666a9b6cbd16fdf"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6120979d6fcb29a6490926c7a0ba398b37b7a2b6b736c00b5fcd0d8ff1c6e3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d2b9de0f3e0ab1bba3addeb70e1d04a40f12dd94aa6b923d75112a155d37d62"
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