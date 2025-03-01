class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.153.1",
      revision: "1a3e0cb8da2d4fcb62dba675ac33f5b55bca7d64"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1759c3deeb86d32b9f1837b630ba9e175d0523a79a050ad462386ee4e8eebb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72a0a178c0870b32e60a77b1f82e4a6b51fad92805bc1e84a969a12b3e60e033"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd38d6c88f4a44b23ca9ceac84aa431c6cb15b09d8bce6292804089309c6f024"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8d1590d878b69eec7ab99758934400e3c3cdde9c409a81c90c86897147f2aee"
    sha256 cellar: :any_skip_relocation, ventura:       "23add9224e949a8c2b0e0752d709f919fa8f04823b9f8771c72059abff5d961c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30158026006e50810acf8f7137422cd3d926a29d313f1b5fa08f7382d398a218"
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