class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.183.0",
      revision: "84765084a0cb4763ff2cbc323086066ef35f99e2"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb6e0a5facc59a2d5e566f721bd24ec874491f8ba0ebd7c09d8363e70c937676"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e638170bb7e19d56bf9f44e32df2ec2707a152f418080a650bccf625bb497541"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d49b2835ddfb9c15b62296402db3b74c6775461bb4e620d3720df617fab78b1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "04ea76d016749c60394a02f9ed55aa4c1267d18d42efcdb316faeeaf089c4f64"
    sha256 cellar: :any_skip_relocation, ventura:       "551707873153030265fdf07f710a58fae3180c0438400c440f57c4c99944263a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "637f5bd60953430c392bba0831326e7ea41e84364b957c9782e495a901c5e7f9"
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
    assert_match "invalid access token",
                 shell_output(bin/"pulumi new aws-typescript --generate-only --force --yes 2>&1", 255)
  end
end