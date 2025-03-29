class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.159.0",
      revision: "f658c3fc22a23a0b7437a517a6d6d282d5ac6ff2"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51d2dc4f137b3e216e9fc9cf2c856732872d75e21c9ede8ef0f61ca4dda4ff8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1d7ba217f7c420e2f2c965623cb5499a31556292877d8cfa6c1561a34ec3e49"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "13a9aa37f82eaba992cd61246b1e9c42fe374850395c38e2b50f08ef1573d8b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "8222daa1a64b065c7ae24bbbab4ae4790de9f6a3f4969645d0e6b849a7a7dfeb"
    sha256 cellar: :any_skip_relocation, ventura:       "23428c71ca297a913931f78669585cc235e28e539f6ac8a1a96ff479074fcb80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c54f7f02093be54c1e6ec393ea1facbda2bffbc7a728e543110d7d3a509aeb2b"
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
    ENV["PULUMI_HOME"] = testpath
    ENV["PULUMI_TEMPLATE_PATH"] = testpath"templates"
    assert_match "invalid access token",
                 shell_output(bin"pulumi new aws-typescript --generate-only --force --yes 2>&1", 255)
  end
end