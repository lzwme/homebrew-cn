class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.141.0",
      revision: "861144e19a0b41abe7e61eba2750b5cd6747d619"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "616969371789911d3c697f2aa00743d17b778a9e5f3ece2d598bc2a5e72eb593"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2adc12171aa681d345c2f870bf261f19d75bf1ab501c18a16dbd907b02bf69ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1bb4e255506fb7cda706be339d23165d7e3965f736b59792c41ddfbf57cb6c84"
    sha256 cellar: :any_skip_relocation, sonoma:        "6875791c638c85afe2df4bdc5ae93a93179fb15244489a8b39d38271eca0c7cd"
    sha256 cellar: :any_skip_relocation, ventura:       "2aced33f0a41e7a92fd8970c01bc30d2b3df6d363312c141dacdf9d42616ceb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "251ede00f2e84ed2605fb08b6f2a4e3d0132a161e219f984e43b17df33ef2754"
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