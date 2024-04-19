class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.113.1",
      revision: "64bee7d287026dfe9a1e4799e0f31b7e7106b8ca"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e8c96510c39855a01f1e9653ca55d55f5db12b4c0078a6473fafd424cc497b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f97247d0e76a9dfe587f7824387079943f10b7f0d5ec93357ffacbc131c26be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70cca4bcd05ce526c981030c3ade2c3552b552a179ad9f9fe08e816c2769dacf"
    sha256 cellar: :any_skip_relocation, sonoma:         "faf33335b9322f5c5a22c76edd719135cd5e1b7ef3224bb307beff43355e73e4"
    sha256 cellar: :any_skip_relocation, ventura:        "171d0db299150740c41838e1dafbbeb8e23bd0797d48c218462b9f51b59a3458"
    sha256 cellar: :any_skip_relocation, monterey:       "a47ce79ecd09b7cb6979af13d8309e31d8291291b611377e0a6d674537bb1333"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d132425b5605b25babfb272b7eb4b3557ca161097a8d1ab1e916d3a04085304"
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