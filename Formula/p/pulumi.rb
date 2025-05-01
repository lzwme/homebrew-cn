class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.166.0",
      revision: "ae3c33c4d9971c0359a5fe50190650de9dccc188"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c84a63faf98fd3315785675d6f9d5a46215b74d96500153eeb42fefb0f3383ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f3a88f0c619e9b4b01c94970bc5c9fa431a2c8196f17683fe83ac1d7de3c251"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ad2ac04bd87de8b9514fb74246b5b13c9656b4ddc4b16c09a8a3db2d6bc4d873"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3b2fd4ab730f5623f9748e19a9523720b079803d2756cf2e12dd949a896f951"
    sha256 cellar: :any_skip_relocation, ventura:       "a4115489ed4a39a8b9f7f779ec312fef70363a28f030417798d55e031e49dfff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b826465a05367c4f30aab1ed5f76b36c0cbb72291a6b5146937676b955b7ddd"
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
    ENV["PULUMI_HOME"] = testpath
    ENV["PULUMI_TEMPLATE_PATH"] = testpath"templates"
    assert_match "invalid access token",
                 shell_output(bin"pulumi new aws-typescript --generate-only --force --yes 2>&1", 255)
  end
end