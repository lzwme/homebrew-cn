class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.96.0",
      revision: "04d83b4125ae705ce1954c22a50e0c388396ea87"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ec556589fddf5943a54eedb8fae0b96bee1b8ea2fedf40b36db192f1b62523ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88dc43cbeb439cf910ed3b353615432b1793995fee5f09ae61be3fa23945babf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b620d300fedc3293a3e324158a2113a7bba2d26a45e9ac13f50214597b6a5b87"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ecbe9f36bdb3a5c0857818316d090cce0b847a8de65f822eeaeea0ee38fe876"
    sha256 cellar: :any_skip_relocation, ventura:        "163abc049807dd818cc7872315a4498a272fdfd2e07f1f55fcf8e2429fdcd5c9"
    sha256 cellar: :any_skip_relocation, monterey:       "f77955750dffa906c359a452640b9e1c1fe03615ae4d0a65e8f383b3f7a6718d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d78cf7a27bd128b728c34f76a84f18deca061108e5518e31830bf817b6bca4a"
  end

  depends_on "go" => :build

  def install
    cd "./sdk" do
      system "go", "mod", "download"
    end
    cd "./pkg" do
      system "go", "mod", "download"
    end

    system "make", "brew"

    bin.install Dir["#{ENV["GOPATH"]}/bin/pulumi*"]

    # Install shell completions
    generate_completions_from_executable(bin/"pulumi", "gen-completion")
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    system "#{bin}/pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end