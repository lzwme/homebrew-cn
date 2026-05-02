class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.234.0",
      revision: "e802ef2c5b95a4499bffc1f5bc556a0d732a1189"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e11e7e61daf8bb7e514769b453e4d8049c7d5e8a479901231d5d3c1ab25ff5ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f972d498b1a0da3059782b5078089035757e4756597490edd0e7c2c5afcdd4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e9f302764b406b9d21fef5662f0959fb21cff700a2af73ab99aa0e54b74dc14"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4de40b5c22530bc039fd371cd9053d83a881ccf0e35a6de896525f631561d82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3387e2fc53a5f92fc21d0945a2739cb3b87c3b2393fe7ab6a8009257be86af02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3b0e7a48c95e9f38642c397bc75f168c85407336700b8a0e3fb83264e21c8b3"
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