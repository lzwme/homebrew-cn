class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.140.0",
      revision: "e6f10f38505174725afea9d4f81d2338cc1a1113"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7e484c47e11a36afbc13e18ca4a5e182ccfd0785e980e5b60c66ba1b2c4b3d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a75e846484f034f6e53945523019be2c81d301f68433cf2a42dfd5b0e17f0a15"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bec09165a4d1bdf97626391fe0c69ecefe765ce215fa7586bc062915a03ed9db"
    sha256 cellar: :any_skip_relocation, sonoma:        "a581e2ee948bff89e5b0bcee28c58254815eef030edb4ac48a3fc293554597b6"
    sha256 cellar: :any_skip_relocation, ventura:       "aecc105dbf59b9acc2595f8d3b865e70f487e9a6b21413c3a5b1b0128e32da93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b2d71513404d1c339bc6779428f1e728bb9607e036041c3a6bf5d9f0785cc02"
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
    assert_predicate testpath"Pulumi.yaml", :exist?, "Project was not created"
  end
end