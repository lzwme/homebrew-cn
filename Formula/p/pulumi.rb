class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.157.0",
      revision: "9bb96ad59a8628de5faafa8e85b57dde622a04b2"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93fa8652d5f5603e89138bbe919c6602cd8de55d4594e60cb96693f67fb3ad9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64e786d53fd13ddd1f2686bb41c913d528934f40a61ea17316257f9601e30406"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c46c53ed1af13bcfa492bdcaffc535c57030eb2e838d8777c42405fdc91033d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8204e4fc6d617dff61cc4ef51932962e6ddcdea1635e29614cccf6ccb2f6dc56"
    sha256 cellar: :any_skip_relocation, ventura:       "bc45d3da9ab18b97bbca047b5b591956bec248fabac72a0cd58376762cabad55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10fecee426377146c50308114312c85e96954b8936cebc6a8ca883dfc5c928d3"
  end

  depends_on "go" => :build

  def install
    cd ".sdk" do
      system "go", "mod", "download"
    end
    cd ".pkg" do
      system "go", "mod", "download"
    end

    system "make", "brew"

    bin.install Dir["#{ENV["GOPATH"]}binpulumi*"]

    # Install shell completions
    generate_completions_from_executable(bin"pulumi", "gen-completion")
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local:"
    ENV["PULUMI_TEMPLATE_PATH"] = testpath"templates"
    system bin"pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_path_exists testpath"Pulumi.yaml", "Project was not created"
  end
end