class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.134.0",
      revision: "dc6f275f036b031bd32043b77d1e0fcb35d6d55d"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a82ca8ad7e071260def09b44fe0b2fd1e76bae6925d6361adc00eedf361b511f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e572ffb6431e374b3780d25ca0b8ccfadf7b252ebfed40275af57a65c42ee2b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "74ba8a6b69a0beec83371fc53117ecdbcf2149dd11186fcfd1816e85d5010bca"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9f518b889b5f35feb56a93b55c7855f8802f4eafc8972ac9abce7532213c8b1"
    sha256 cellar: :any_skip_relocation, ventura:       "daa3736bd3c2f9f27c2de3665142c77cb9641f29212f00e101dff0ba19f15e98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34499f5e03893f83e8b788b4bf8f64dce4dacd91c7086d48b5d515787388b456"
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