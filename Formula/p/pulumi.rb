class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.185.0",
      revision: "8b4379e7047ed97a80d83fd98a335686c8c145cb"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f25f1e168f30d71cf8ef90a4ee1cf3876c3adecc7a48526761f1ac2d4ecc910"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e0a50b9c8fe74e2c8a55d1fc20b0eb24d83394fc93d7ff551b78835f0aea194"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f8b12e695ee1bc843afaabe9b2e791384a6e662d5c6a089044acdb64a4db1475"
    sha256 cellar: :any_skip_relocation, sonoma:        "035cca50e9cd7fb5e60fa78a30cb6a739cff85accae288a3285d68e2f3a4b9ed"
    sha256 cellar: :any_skip_relocation, ventura:       "c5cf948278ab16a33fecf2fc707ed2a92e3d0ab5b524a827849930cc6ed7badb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef8b479081c4031ebdd2eca6aead94e02a4076f44974cd2830e1a736a5257cc3"
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
                 shell_output(bin/"pulumi new aws-typescript --generate-only --force --yes 2>&1", 255)
  end
end