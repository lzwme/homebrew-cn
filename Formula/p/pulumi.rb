class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.160.0",
      revision: "1890192b422b2f9cea2b4e7ab935512080c6d2b1"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a315d255b438d755ca32c2c45168e2dd3734de98b15c01b1a2227b3219583320"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "125fabd9e9fd9bda87ee69016e839777fd3cff224ba05d6ca2a9e2ea96b58d6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fab80f67d563d92b2eebe0ce138a72e5b1e5d33a99ebf1592cdfa6630c55ee7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f027ab56186b33e616f39191dec74aaa8ea9ad1a94c69f826c1756f39182b4e"
    sha256 cellar: :any_skip_relocation, ventura:       "ded1064b5d727577b54d4bc2055850175c8c6b1b595a332f6d3dc9aab2e19892"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c30d76f91c3457a3ab6c67a5095b65cca3fd4278529987ed1a4d01639255ce47"
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