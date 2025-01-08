class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.145.0",
      revision: "01dc024fe7b95651171b3b31c99918de6c43ae9e"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46314b27468d6d712952d1ce3506e078768ea4b358706b865775ea4878d705e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1793930fa0f1dbf6580e1bbf45af099563df89f78604d7c0418e95780cb26e76"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7bcf4bb7149cc68ab99c056e7e2a3fb039da2462b512cef97083d3d258f14dfb"
    sha256 cellar: :any_skip_relocation, sonoma:        "bddedfe891ea36513a9c1edd1f0960089f7a73b850e16b6f8a8f88603cdce131"
    sha256 cellar: :any_skip_relocation, ventura:       "67203b642f95b46c9bb3ce65b71e6c5451d16363dfd3dda650e7aa103803498b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6782031df73bfbb4303b3f76a130f5a42756222eb12bec4e7d7a50a8c17259d"
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