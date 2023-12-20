class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.98.0",
      revision: "a9a88fa2d13b5ca28f6dc5a36615128dc3403f79"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "77a4aa67ee98bcf6bcaba8d1d19bb810dd0c93992ade8e2c0707e3bb5c4ca17f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0b07ec228e1cd0fce0c3975f6e8329e2e8199b55df4147abafc644a969deff1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "241705226c89e4965c9e14437c15f4e8060bf9dd80237bc93598ba1843fe8dc1"
    sha256 cellar: :any_skip_relocation, sonoma:         "18510acd8ee4a55ff03f1d9d93ca686d424b1c082e21dfc0f9b1b20e7d1559f2"
    sha256 cellar: :any_skip_relocation, ventura:        "e5def4d7cf3551b33ff79828372ac25903cdf2b8f304cbdadfd15fc13f00117b"
    sha256 cellar: :any_skip_relocation, monterey:       "fa642353e6df2b0b205acc154495bcf4b272900278ee8eb93a4912cdfd7f72a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82756f04d07648df2e7212f9d2be11c64c438b7fd695470e342ba63ce6136148"
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