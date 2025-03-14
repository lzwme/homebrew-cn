class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.156.0",
      revision: "e9f7fa5d1cbc274b221862ec54bc6cbc8f2c6fe0"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3c1dbbd549ade26454e520447f437b7481d3851b6e2329836799355d03207d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "611e906fd9f576b3aa552debfc47162a4a47f6c7130a9e845b526fea54ba66e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b8aaf7744216f3b52a6d77fbabf36c57f46bb62e66ee866130e7f5622badbd7"
    sha256 cellar: :any_skip_relocation, sonoma:        "df3d5775b8a96cdbb11af7fbe75fb36408c86ded7a7aa72288a8e7471a13c219"
    sha256 cellar: :any_skip_relocation, ventura:       "15c9fc408bb78e34f066f7f8a1a61767a909bf861af60efb3f7aaf0732541407"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc938e42f5e6911606bc3fdcb332e3abe2b71f35c51f83ce0dde0ae0680dc24a"
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