class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.176.0",
      revision: "3c5f2ccda98bd7e506f278bc0faeaa6c8c2f94d5"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "772f54857cf512fc3dbfa06990c59c18d4e12d51d369860db49a9c2350280dc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79245ea6fe097f007ed1ce205c308715c6204e7cac18bc1f4aa250976c500977"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bdb0df94ea9a649986f55d1e168373045a969db9f0358e3299bf7fdb11910efd"
    sha256 cellar: :any_skip_relocation, sonoma:        "09c60ce2dc04e1ee21b0ee214219a38abdc8b9a0b710f2cdc1665056073b9d9a"
    sha256 cellar: :any_skip_relocation, ventura:       "2ee2982fc00a50b66c609c1f2b9cabe9bee873b134fce7d2287bd5d5166ab520"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b160de4ed6bb1e06e1cf5bd40c9ad7b1664b40b20e942fbd33abd803e2fc2aa0"
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