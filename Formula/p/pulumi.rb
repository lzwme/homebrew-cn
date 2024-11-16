class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.139.0",
      revision: "9a508794531630adb9eb46ea15a759be4923d69b"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76f14cfbb6ffeb41b9975a88dbb1d856be1e71390c0815529995fd8e2cd1a966"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "200a9e12b926e1d0e9fa0bb7563104c7919696eaf313768da4fe1a81832b03d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "41d0f861fa4148afc96a295c727a53de89bb0a7ff8aaa040123bb73779dc2357"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4a433a7d9c1accfb21247f015c23de522e5ace3b624d53fcca578eab07d17f3"
    sha256 cellar: :any_skip_relocation, ventura:       "d7092d026d9ee8cf0181f5c12ca06fda42128dfd69b775c1e822919e05e26dc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71217b7a5bddceb806026057b363d6faecc9c1c70725995f12d423cefc22428c"
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