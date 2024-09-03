class ApifyCli < Formula
  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-0.20.6.tgz"
  sha256 "81df5c90a3ee1c6108a37dbdca059fc73f21c03d4dc59285aefdc3b1afda75e1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1b9c24b4dd81c8533d60e030f7f95f2e083f99fecfa503535c578fb7fcf46c4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b9c24b4dd81c8533d60e030f7f95f2e083f99fecfa503535c578fb7fcf46c4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b9c24b4dd81c8533d60e030f7f95f2e083f99fecfa503535c578fb7fcf46c4e"
    sha256 cellar: :any_skip_relocation, sonoma:         "447c0a91140d0ffb35fe84993c5869aa927151560c647a2d3677d17d0c836515"
    sha256 cellar: :any_skip_relocation, ventura:        "447c0a91140d0ffb35fe84993c5869aa927151560c647a2d3677d17d0c836515"
    sha256 cellar: :any_skip_relocation, monterey:       "447c0a91140d0ffb35fe84993c5869aa927151560c647a2d3677d17d0c836515"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfa8c52be1410b57e69253a47e336a1258b329b142983a8106194efbf79499f8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/apify init -y testing-actor 2>&1")
    assert_includes output, "Success: The Actor has been initialized in the current directory"
    assert_predicate testpath/"storage/key_value_stores/default/INPUT.json", :exist?

    assert_includes shell_output("#{bin}/apify --version 2>&1"), version.to_s
  end
end