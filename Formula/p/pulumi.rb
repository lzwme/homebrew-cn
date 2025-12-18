class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.213.0",
      revision: "b5f037ab6d0f2faa594f956b93dad82404fabe0f"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07ee0f075f14ee6292d06d580cdc2a5cd4816af7072b9217f50d3b9f9d7d9ee4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a81348917a4cee3692675ca500472ec68ffc7bdf19a35cab2b244def6d987ebd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0ca6d7b17983b3bf489ec5c9d7a66ffc49ac22ad5d18f61929b6e40c7ceac2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "febdc65d14101b09f51590727f81d929e5741e0a2619fd32fa1cbabc5cf5ab3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c96664311b495f51d9c65f1bb5f153ed7637a6ae0194fa47b0b20efb1363f0da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5fbf6bf2406db525f81f3b2b30604fe1c5aa73620eb39454376e1283c89d612"
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