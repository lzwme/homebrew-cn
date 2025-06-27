class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.180.0",
      revision: "1520431f8e6a4bbdadd3a7b325faaeec682ed6b5"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42b19b4f950555bcc0396020878399b4eb790d48510cce84242439f4a729ee95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e3891f3a3d95df54f3e80c234c5edcfb58122a82be7910bb4c5d3b522e262cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c6de163092fd8fbd7eb933f565713f10b430697f484bdc572ce0543bb0b2427f"
    sha256 cellar: :any_skip_relocation, sonoma:        "07f2b512a51c644e882bcbea0d969f4b00ae98f5585a1ddfb852bafe247d62f9"
    sha256 cellar: :any_skip_relocation, ventura:       "23b6eeb6d5c5e7202fc17aee7d36b21a80ab745f526dc65f1790aca6a7175702"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "711210a5629011a85e9cb112cb27b4507112b34d04790b7874234016ae720469"
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