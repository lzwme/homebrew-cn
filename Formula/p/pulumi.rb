class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.134.1",
      revision: "d1bdfbeb9eb93b3626585a49ae67fb4a08297bce"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01f5edaf75e52877ea64c4ec2591234dd03540b1ebe8c4fdc31f1944f9e371d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d887c6976443746f2fe0cf0b2dcc2a1c4ca2dcae2acc4ff5175f223f0dace03b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0612cb5eb6f389ec161057b4242c1bba846e914cb3e0bea271161adb1cc2fe92"
    sha256 cellar: :any_skip_relocation, sonoma:        "da1a945ce6585a23e62777ffed2f8d5b9a4c387db97e0b344c13b4b7464badef"
    sha256 cellar: :any_skip_relocation, ventura:       "3d40c0c9f81d3298cf10c84f8eb684d7c83d0a42598f0da859c66ac6aabdbe25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a7915d231c2ca58ab25f5f9dac09e8fece81c825ed0b2331aab4ea6cd0cf48f"
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
    assert_predicate testpath"Pulumi.yaml", :exist?, "Project was not created"
  end
end