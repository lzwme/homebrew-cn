class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.117.0",
      revision: "7273bc02c927cc6a6070723289fdc041b8902bb1"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8a2a7fe2374cd52fe1b65f338d0d1012433ce5a18b8d56ebd9ec3ef293eab809"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cba5d9c8416f7086c25edf79eb4a78090a5d05fbd1ce66e46201c30cae0c4616"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6b357bb9b766fe69402cc96a0b21078b11428aaf2ce25742fa9227a6bae8838"
    sha256 cellar: :any_skip_relocation, sonoma:         "5de0dc9417e9b70cdfc5087dab5ddafbf0006c0d4315f3db57a509a7c9bb3337"
    sha256 cellar: :any_skip_relocation, ventura:        "8073d0d2e226a6763c8a84db6003fa4a53d1d19b8592d42f14c71cf2d47453c9"
    sha256 cellar: :any_skip_relocation, monterey:       "c93f7c6dbb1912d2dcd91838ad782b0c26e61d9e7f360a9bfd55b6fdf394948f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4aa160552cd7e9b319ad6887b863b6f07266c637c04076d4dae9e8f041ddf9e"
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