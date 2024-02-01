class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.104.0",
      revision: "55edc30d687760dbe80796279c24da23eb9da8ef"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bcc7ee164556392104608beb8bc2cf2809993a6fbc05dac5902417e6610886eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3aac788b449b5db6f17e2ab18d809ced7d5deec6f579772a0d96fdad34fda71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0dd50800ea7872748fd8d5ac4343d169965db4c799c2843fabf0d75bf42521d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "f7ed8f783c334f26f13431b8388a739e89fb6880ec359d4b85490f5e58d5d99f"
    sha256 cellar: :any_skip_relocation, ventura:        "b400988babc613f138b3deb88b5aa6c502a0701852f6ec023608476216e8b63e"
    sha256 cellar: :any_skip_relocation, monterey:       "65f4e3ca41a8b1687a0b1352907968c7db607545d6a8bf2ac337144da7b1d54c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25cd6414a324541d093f9458bba4d173d7c401cba3396bd59d94379b07583838"
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
    system "#{bin}pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath"Pulumi.yaml", :exist?, "Project was not created"
  end
end