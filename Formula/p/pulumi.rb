class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.102.0",
      revision: "2a97e7900efe13dd51ecbd519fa0621add538feb"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa4aeaa4890c7552aac8a43ddc6aa2971abcd5d62ee3b23312bc354235b53233"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "721230aa0c91fbcb5b8d0470e9e9947ab218e12963e6133faf20edfc900fe353"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b393e7e82362778798f867ec751b90f98b11484862fc184f1589147f046d9301"
    sha256 cellar: :any_skip_relocation, sonoma:         "066415eb66843e9df25dffda8a3f3caef64beee1030c24247e8c8fd64f80f9ee"
    sha256 cellar: :any_skip_relocation, ventura:        "d0313b1775736bfa3a2b4c3f3f6c9eb0d58f914983a459cf8ef31a3b879ebdc3"
    sha256 cellar: :any_skip_relocation, monterey:       "4f73be71287625d3c2a7c80b1f653db7367710d29d86fa02a01daf8268b0ac4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a34ba74a831fac8219b812e9917de4e350f13cd03648382a7adda63c9c18ed13"
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