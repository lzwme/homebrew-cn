class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.171.0",
      revision: "f3d692d442223b23f7c7b93b1105acacd4efbf21"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5280cb9adf8ae0ac6cea56738081315de50638d9d6a646114da8ac3d30d50644"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2e2a2216a67cc581ba6b0c4f202940e18146de65ebf3614e8481c9a2ef84caf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a95ad16bf64c0a8603c961e711d9f76de2adac2793bfb9059d91d59c3102b29a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e44cfb400bae9006d9a8ab97934cb37bd3850b7dc5d55a80729df8613a662d00"
    sha256 cellar: :any_skip_relocation, ventura:       "a1ae55cbdc92b29a1ea1e3fcb90fc2a0c49ac43f1d0ed68a0661b47cffa678f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ac193b819e0b3e0c4f56b6e8c31c999acac241d418b143e5a8d0c18129b1aa9"
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