class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.218.0",
      revision: "da9b84347b4f5c40e5b625f0285cd81afbe4ade1"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3934487109e171082ed00a0c8a3497c834a5c44c57aa45f4672970100ffe1a87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bafc3ede1ed39299da90537e470408a21305d7105909624b447688c2b0b8f54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d400796fb362a16a5c7d262a6c6ad33bb010cd697d1387c0dfb2cdcf1d717083"
    sha256 cellar: :any_skip_relocation, sonoma:        "234d1cbadddbd14d08b3da012029d345f665e2e85eca0b38f16ac9cd9d31b4c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d45acf102458630ad6095ed96e952b44a11a97df91890048a5a9e9f6c3cd02ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fbb4d146e5c6975262792970448e2b714e1542ce5c97e693524dd764507ab97"
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