class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.68.0",
      revision: "31559f7561d9f25f97ddd1cdabfe281f37f88d58"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a5752e3419ea846f91624fdde494a973f1bc72482420d3ffd768f8e3f49d525"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "056d10b56e27218df748a6ce444afdc17b0fc427bae055fa1dcc389e4a7f40b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5504a4660b8bb8190d0c77f97aee7c0805c0a80a85b95a1d127409474436d15b"
    sha256 cellar: :any_skip_relocation, ventura:        "f5415b43def24745c4cd156eec5b0979fab70c2ce78494155a8a929fd25b6ba8"
    sha256 cellar: :any_skip_relocation, monterey:       "328b1fa51de11e1eabe530d18f25b530c3d9db046620503368118e93fc8088b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5a16e7e3ce7c0101315404106903a1c059c724c5fabfdb74731b14a62b5316e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16f0d5434d1c7739d21bda638ea10d5608549dea3af581a1e358396b4e2a6a7b"
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