class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.220.0",
      revision: "e8ecd95a5ecb4baa93f35866ec34e94fa785b1c5"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9408304ae169b45ea565a17cb15fb01a3f8e0267f46b73a02232c4e3672ba544"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84a8fa6c165744e72b9c69328f0df43b6e7b94e1febb85cdc08645b91d71db99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34daa259ed4dcb912291f9c2973e092828e7e8ccc1e0e2333f7e419041fb0def"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e4a7bc215855fde1beca365c2cd66885212cea1db0b47c6325391eeac454721"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "745b3c9d230341a2c24ba1d503de40640c5c78eead85acc8afcc49ada60526af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e4046b353b900813e6eafd877639e5c7cf951e04a705c38b388cf91a5480be7"
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