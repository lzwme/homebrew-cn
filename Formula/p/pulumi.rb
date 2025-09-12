class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.195.0",
      revision: "04eeef76470b2ab1f24538c8cb83ecb36458f99e"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "666f5e91e93432a791b8f8193aba17cafc3ec03725e4ed547571a680f1a3086f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de32602e0016e2f7aad0368712026c613ecd5fa76a18a09ed218500082bf79d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1c9c227ca3b0a03adebd4cc11fed00a9223b64c24b035ed32bff4c5693a65097"
    sha256 cellar: :any_skip_relocation, sonoma:        "faf62b023552f07505f2462e936034b8008e9854984edb3114bc8474c64a68bd"
    sha256 cellar: :any_skip_relocation, ventura:       "c06fadfcd52b566b1368c7baca48559eae795a1761bbd237ac6f352360298338"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28ae811bb5e7564b410b292a4bc1604290732f6cdbca1f8181bccba3664d7c6c"
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
    assert_match "Your new project is ready to go!",
                 shell_output("#{bin}/pulumi new aws-typescript --generate-only --force --yes")
  end
end