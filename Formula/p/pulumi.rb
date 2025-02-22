class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.152.0",
      revision: "ede672731f49f17ab149f125fb782dc598f8785e"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7954719ef58b6bf5b7991fc24bb1f79ed28e9cf4ffcf1a472d946cf607a13b77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbb962fbbc7f2d856e6eddf7b9003a5ff2fee69a1509b328277d0a446f05b942"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f0ec5402b606aad123b9d62815094fc479e06d5d090beae072bf978dda5671ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f6051145648a07f161280f487ed90a9b26331c2dd328b0e16d6996da5c84820"
    sha256 cellar: :any_skip_relocation, ventura:       "d44964db72fc48a616f4b97209fb1761c94a79b14e42a86f86d05122d4769502"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8619e6127986f6e3299c8c8cc4b9fd262d2c7760029bd68d3e8002e7d737699"
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