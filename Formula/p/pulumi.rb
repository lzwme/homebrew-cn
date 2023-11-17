class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.94.1",
      revision: "3af9af4a817aaebcf95700fb45b7dc02ffb7527f"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0628f1e62887459fd84009c2af085bc12b89870c6ad6fe011aea6cf29bbb0870"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a805845a883cb37caa8b2a6462e9f79911788819b4ccdcf67db08187cf1c29c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe9310f94a338e3b783040ed91a689a6086e5b4057efe129e802a610fe1f81ad"
    sha256 cellar: :any_skip_relocation, sonoma:         "54e77ae7eb8b1285f3aaaf98f0128fa16e8983632b533fab8585422d95ebe4b3"
    sha256 cellar: :any_skip_relocation, ventura:        "8f0d8f5648c22d9909489e0ae3d0f2904d68d51c510104b4989cb2e00395b62a"
    sha256 cellar: :any_skip_relocation, monterey:       "acfb9d0c456dc22790bc759cfc75d6682ba14aef2205f9ce8b83e3fe7ae55d42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f95d08df0e6882ea39f222e0875f6767afc7368808d839058dcfd759b9dedf9d"
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