class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.93.0",
      revision: "76ac4a448aa1a744839ac23fe1e5b3f11106d8db"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "49f93e1bf1aff4426b767a07887ba5db89a2f97e3f36e1a4b94b48a4b5361104"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd84dd019da1313aec2d2eaa83f86caf994d574fb72e8dc8fd791ee800ff3ee0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ee7b13bc733f86fa8412c14d6c60d04c64d301aaef61591cc8baded9cf3888e"
    sha256 cellar: :any_skip_relocation, sonoma:         "c5e2f2468784365c87522797da30a09b3ed3be1ab2ebfcac8815d39f78630797"
    sha256 cellar: :any_skip_relocation, ventura:        "bad323d4d2b71f566fb16ce611dbb0dfe8b2a0a373d9925a392d18dab250fff2"
    sha256 cellar: :any_skip_relocation, monterey:       "7bec4ff6a8cbaf2380d84efc8e1889244cdabb9396f92dd99b463fe27131bad6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ff8dced040f64f442b232e67fcc4b200f97d2d61d8725b6f92f530e5b3f21be"
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