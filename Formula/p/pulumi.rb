class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.105.0",
      revision: "53fe198a8de660214016430156c7d5782d10fcd3"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "58543fd2deef7d859afacd2956c1f015019b44f9d61f5020e210c5bc9556d838"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eec7131e0b52e79f8e94a175f321d9f2ad31240cf4d0dac0a1137d2c89abed17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb86f924dd30d9c70e8652243b124c98954ff21178d0bdbafea16acc71395a3f"
    sha256 cellar: :any_skip_relocation, sonoma:         "7eca8364a9489b0fdb18566cac3bb85058408e8840162b933f3b8cc7551344d4"
    sha256 cellar: :any_skip_relocation, ventura:        "9b5fcbef8c5b3268554d0d89a1a190cced8dc1d3d18519a5feb67b1712351d01"
    sha256 cellar: :any_skip_relocation, monterey:       "0792f288d91adab3b2786e72a5cc8a2f96d383c1b5c8fb7fb09ea0c57e0f7157"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0240a1f8da71079f343b00ceead8199aa2b782a22751bb8214a47d71f8bccabf"
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