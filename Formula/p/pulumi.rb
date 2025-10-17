class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.203.0",
      revision: "8b0ee4d225d4d22a172c37cc42d813a397c33c22"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb27effe624ca77db3c228317271a1f69584bd9a2c1ac7946d15b704bba7c2fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53bb576208cdf622a315a70e7efac667d5d31871d4ae933fcdf90f883cd13150"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "651bacbea018e3fe91d0e392f069582aca63c5a1e914a414f4b6602fea1cf6cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "e248df9c4d082a5ed88fbc0ff506c17dc4e0a7fc3cd5b31ce3399c23050c8158"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "402b86a800e1ed824b6140d8003f6ff435c0787c6e9ab354000694342c5b104b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b91b42daba634344c4e6b341f5d8327bdee435e0c83605c0e2d806971466ef40"
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
    ENV["PULUMI_HOME"] = testpath
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    assert_match "Your new project is ready to go!",
                 shell_output("#{bin}/pulumi new aws-typescript --generate-only --force --yes")
  end
end