class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.219.0",
      revision: "11ec8dc8249b56bedb4496926cc6e4133c5f2532"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d9a36486523eb2b7a5b9e253c085821d81c075e8ac43f4a0b8ebaf0d9179aa6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb74a57cd1426f16fbaaecddb12cae06b7bd8623f41f62c39ad36b5d206c309f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfff9ccf37e92a949b41d57c42509cc0240acdb8f4d2700f714ad19b58978f77"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0477fb3ca958e91e9edb24d675e2737be426c4d4a8f1f6878812ae4d2f1f300"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f412098be366193e6d23cf87f21f4775837ee518653e5ab58dab48ac8c8470bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c41bf7bd923545c0809e06e58c6d26a7acc0401eecc5fd802b6cbe281a291c8"
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