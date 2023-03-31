class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.60.1",
      revision: "f63d8a774ae9b5ce7ef81ddc8015731f5bd61aab"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e880ba0b98363d9e2e35bfb9c44a1b5721b403150ba01ae47115917c21db3bf4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d73d538bd935ced524374c01acb727f4264361de0432e5ca89892ddea816f057"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea8d995b46230146d776a98050c96ed26c0759f88a1177b9717f28f60827f06e"
    sha256 cellar: :any_skip_relocation, ventura:        "929478fe3e633bfc05abca68d4671ed67809ee0b8df95bb7cd0ca4eed4780892"
    sha256 cellar: :any_skip_relocation, monterey:       "221f36ea624ca92180584cba1c8624b2bae4374efb65cd75254a590d63a165b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2e71e11cd235ac81aafdde14e97508a6cbf3031bf0f5df2586a75a5bbe531e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "422229dc6b59673c583bcbb03ba2bc8a64af0bd7138c1280cd328f066e50a680"
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
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    system "#{bin}/pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end