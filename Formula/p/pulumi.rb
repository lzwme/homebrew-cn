class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.149.0",
      revision: "ab282f706a4de7a4c386a07a1f5860a760d8ec15"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de17e75c4a982d3a95fa0ba9dcef1325a436b7d991aaa054c802cc066af39351"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8924102d78b5e15d7f985477c5441d13935423b18f4601d5fc6e26feb7bd9fb9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8452d0c1f241c0b429b171f99049f8b6bde106d533f83ac5516bb807b5e3947f"
    sha256 cellar: :any_skip_relocation, sonoma:        "8107a53d64f018c6fbacb29ddd0a48a05ee2af8e7c5d3dda80c077968dfa10b1"
    sha256 cellar: :any_skip_relocation, ventura:       "95a3d10f6d7ffc60ad2753020a4ebf133e9c8c2c201afc1e0fece1be6c8ce563"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af4a5e3a36dcfb8187fe59840f3f3663fb42bd0df27bf841e63bae4bcafd5605"
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