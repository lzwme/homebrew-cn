class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.122.0",
      revision: "2f4b26b6810704691a2ea80e56b92739babc56a2"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88b383d25e65a40650bf0201e8d82c7deed21076945864ef558a1bf5c68f4275"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0438c67fc3304235c58c6c078780cfc2331d505cffccdb773035741ffd4ef676"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "086e1819e336e25211cbdf5147e50c43dcf1f12752492851bbae27e4b7531713"
    sha256 cellar: :any_skip_relocation, sonoma:         "f2a98bbff152ae28b225923e43deabd32d2b0155f758dd996c999d76ae4546f0"
    sha256 cellar: :any_skip_relocation, ventura:        "41a26ccf07291e2b71199553258349dc7bb2fa1549875ea355ae358ba2eb582b"
    sha256 cellar: :any_skip_relocation, monterey:       "5b13d033ae7faa0d9356b9aa122415e63c4604ca26f4f91868b819cf4e1fa9d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f4aec2e8c122d99593c119ea09ba166fef0c2262508ed0e46109f3718a037e5"
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