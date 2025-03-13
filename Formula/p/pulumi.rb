class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.155.0",
      revision: "dcd68d9de2cb130a19d74d15cb236effe589d47e"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1acd388711c6b5a77bfac17b3d0e33e04154ad2a4b968fa8975b9a63e6558215"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a558635d5212bfeb75b2df21558fc1927d38c6ffcbbf0de015aec49ac1811b37"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68bb1b548e259a3e885d6d55b3db21107e43105c70b8a983a69927dbade5ed55"
    sha256 cellar: :any_skip_relocation, sonoma:        "50030bd2a9c45cc5f5ed46fc91be8e284949f209bfb34ef07354b6ad827591aa"
    sha256 cellar: :any_skip_relocation, ventura:       "051e052e53925bb0803fd249841747c54e1e9e0edb55b5b376ebe98cdd2e5276"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "237b7cfb46629612aee2a56352015e2a6d91bb8a6c71748fd27528a91dfaf7ad"
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
    system bin"pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_path_exists testpath"Pulumi.yaml", "Project was not created"
  end
end