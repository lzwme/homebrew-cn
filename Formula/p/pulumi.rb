class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.189.0",
      revision: "ce61b8cbb1ac9b31a0d7f5b7d63ab5be54593217"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6efddd4c5593094f2b7ade262940c92addfb23d155eec74ea9a783249e0d59e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c20d4464ff691b9eea5e42526b7c44e0bef82d7c13ae53ead01dcdbfccee63f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "38a4dc652fa1267447ca2d5716c42060d09053adadf4b4cab6145e52489be33c"
    sha256 cellar: :any_skip_relocation, sonoma:        "44df5fd379d33600485fdd7d66cc1c12a8c5c708478252c9c8495a00153a1924"
    sha256 cellar: :any_skip_relocation, ventura:       "87d9672c43fa1588523ec62aa588f62b865703f12ec8aba0155c7d0b151dab35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ea75c80a7e87250339786d6f1c6f34ee0cd2492343b4d27be400e2d2b5a54b5"
  end

  depends_on "go" => :build

  def install
    cd "./sdk" do
      system "go", "mod", "download"
    end
    cd "./pkg" do
      system "go", "mod", "download"
    end

    system "make", "brew"

    bin.install Dir["#{ENV["GOPATH"]}/bin/pulumi*"]

    # Install shell completions
    generate_completions_from_executable(bin/"pulumi", "gen-completion")
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_HOME"] = testpath
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    assert_match "invalid access token",
                 shell_output("#{bin}/pulumi new aws-typescript --generate-only --force --yes 2>&1", 255)
  end
end