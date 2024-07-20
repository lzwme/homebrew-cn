class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.125.0",
      revision: "abd3b4d8d5e5b3e46a17f74b65a1239626320ce3"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fbaa148adbfec740d6f5f6d5d7034065e199ce803bdc54eeb7badf14598f601b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95c16eee79bedccdfdf7cc0dbef81156d799419a8cfefd78f677e71ff74fb1b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2761bf01515b6617f3837aa2a196aff21a5c9352044e17454aeffdee87323109"
    sha256 cellar: :any_skip_relocation, sonoma:         "d6494a2f777e51903ed7e35f8122aeb2b45c075119641deed4d3bff2783baed8"
    sha256 cellar: :any_skip_relocation, ventura:        "cc1df473fcac01b467fe8303aff1f6ab9748eec79e120d7461023d8ff0d3a4bd"
    sha256 cellar: :any_skip_relocation, monterey:       "97b2c0311d562a01a4d79c1fa956ff90ace69d5999627538a67723da28868d11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d338597fa918e2248d1a03d034cf9060ed4e64c5bc483988520ab67c40b58dd"
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
    system "#{bin}pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath"Pulumi.yaml", :exist?, "Project was not created"
  end
end