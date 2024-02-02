class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.104.2",
      revision: "7bb2a3c2acec59d36411212d9cba7d3b1cc8f840"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5556810f4b93b0c625f8652e4b3df45eaa63ef8be1ca6c0c2ef2b3aab741b54c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6680b98f6cc4216fed7c64f78800e4862a3ac5003f67ff28baf18ea45e34d56b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c97c5a4665a10f79ba8041708e2cc806a5d719fd10e6e980ca4f6aa5d39f2a9f"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae060e7b693e858a4cad928b8c8257f04e86b5e31786496314f0ff047204cea3"
    sha256 cellar: :any_skip_relocation, ventura:        "63574603472dc8af6629be894f5a97f86c7259356939cff2595502f3da353d38"
    sha256 cellar: :any_skip_relocation, monterey:       "51bd8aa69ce6d96e692114e9a6ee98ec8bf0f160ab18c878f8358a8762e1d47b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3933f0c8ff299e4a790c9217018eae934c4fd6036b3230d0ea2c7252fbe06cc"
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