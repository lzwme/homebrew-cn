class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.103.1",
      revision: "db0bcc2d9f2935e1abf1332746cb90c869e8733c"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "714aee25ff42433f3b7173c5a3a0d9d8715bfb2086eec9ae2bf09db5ee593710"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b5d4f66fdb183017f565cf375d3f3c2ae3a74696c95d8f40ab8c1f8cb378fcb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5c8b767f81b62efc8651614d174ca3cde7f8f7f0c2887e604a86a2e3ac2e61b"
    sha256 cellar: :any_skip_relocation, sonoma:         "1f0b71b37d4dc789052f1e912437f61ae73a0a0d0c07cf8403be454c2c288cf8"
    sha256 cellar: :any_skip_relocation, ventura:        "880eee2061081e43c7458dd2012007fad7c67b8db3a10a2129b196ff7446e13f"
    sha256 cellar: :any_skip_relocation, monterey:       "0b68e2b19d53e3074007f1349a80818af7fddd0c7248a3ca56fa80b6240f9759"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "849534184ddb1c248e3d727be9ef756ea6a621fd9abdb7926aafb9f8e83bce2e"
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