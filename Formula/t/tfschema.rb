class Tfschema < Formula
  desc "Schema inspector for Terraform providers"
  homepage "https://github.com/minamijoyo/tfschema"
  url "https://ghproxy.com/https://github.com/minamijoyo/tfschema/archive/refs/tags/v0.7.6.tar.gz"
  sha256 "a441e65a8432b4e80732d7448f932e126a3a8d83d2f6e65a04d8ad49a60869f1"
  license "MIT"
  head "https://github.com/minamijoyo/tfschema.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9df80dc04f36cce847a83eee4057df42afd0fa0f7da186ebb732bdd71c07185d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba7e33bf562737b3dc9cb99eda6a2e24ee43d287f16dbb8acd9158c5b64fe758"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2305e8f8b8697ca6aa517a026ee79229e18c72809b6a0020e122d688aa35f9f"
    sha256 cellar: :any_skip_relocation, sonoma:         "7ad0bbf93a0c28ac6255ef55387571de7f250fe7b5a36571adf769b008e7b69a"
    sha256 cellar: :any_skip_relocation, ventura:        "28511dea75868ca4a87616a69063d2cbaf3960f911825181c04d41c4704bf8a1"
    sha256 cellar: :any_skip_relocation, monterey:       "c4ab9a937e5efbc86acc234a2a66d0fa1254a6d57b71de8670cd2d12e846bce5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "258c47b8b8d81c10546cf37431cff48492ab939a83cfa25f396a79943d5175e4"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"provider.tf").write "provider \"aws\" {}"
    system Formula["terraform"].bin/"terraform", "init"
    assert_match "permissions_boundary", shell_output("#{bin}/tfschema resource show aws_iam_user")

    assert_match version.to_s, shell_output("#{bin}/tfschema --version")
  end
end