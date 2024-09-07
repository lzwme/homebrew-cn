class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.131.0",
      revision: "62293f05f79905c029238a3cecdcd3eb8b2fb9c0"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15759f25e6359480a02645a8dbbf3b13301190dca0ac79234fc40440716dcc8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e87ddc4882f66c8cfb08d8a0805172fc7b544bf9eaf1965fbb216a75ed0b300"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3e55cf482df831a3aac323cac7d0687348e6c11441181566d907e160b2a6b1e"
    sha256 cellar: :any_skip_relocation, sonoma:         "5225bd2dca559efe515a41ab9550d8d30e4e83a8f5f55d716ce12346e63b0cec"
    sha256 cellar: :any_skip_relocation, ventura:        "2a7f800127308c401e8e0ca05cdfdd8438342ae2e45750fbdc6fc9da31c9d742"
    sha256 cellar: :any_skip_relocation, monterey:       "ee68ba0fa61b48b1179fb2552483b16a759cd77ffdc71c106accd67e917cb482"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c718c18cc1e00aac3406355d6178cff92cc2801fc39f95dd81cf8a1e964704e"
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