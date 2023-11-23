class Tfschema < Formula
  desc "Schema inspector for Terraform/OpenTofu providers"
  homepage "https://github.com/minamijoyo/tfschema"
  url "https://ghproxy.com/https://github.com/minamijoyo/tfschema/archive/refs/tags/v0.7.7.tar.gz"
  sha256 "fcd81602862205c0d9247fa4cde7240ed5cc4a687b71f55459f45a1e5870dc77"
  license "MIT"
  head "https://github.com/minamijoyo/tfschema.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "74250df8040a6c23db85445a73e545e3adbdbd9f9f4799955fbcf01db7bc8730"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2782ac5de82d7956c24678c295cc472436c64495929c62e5c33f4bcc571c408d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24dfc84526a9ec143e244018b1fa0fe0d53df0e746cb1a4dcdebcd1be76057f7"
    sha256 cellar: :any_skip_relocation, sonoma:         "5862ef6e3f048a678cfee92a4da4ba53765c8aaf573650f47bdc1b976e4913e6"
    sha256 cellar: :any_skip_relocation, ventura:        "46e79b9ab7c23ceb60f0710edea4bdafccb126d5c7e1cbee0530894755a49913"
    sha256 cellar: :any_skip_relocation, monterey:       "2f8d0c3ca4571bfb0ffe0784b74819a9f9974db4799357025868df46f08460d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fe0e84c0646a7e5d25f0b8f62a19fdd9bf3cd9bde2ab13df322b5bfa2639594"
  end

  depends_on "go" => :build
  depends_on "opentofu" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"provider.tf").write "provider \"aws\" {}"
    system Formula["opentofu"].bin/"tofu", "init"
    assert_match "permissions_boundary", shell_output("#{bin}/tfschema resource show aws_iam_user")

    assert_match version.to_s, shell_output("#{bin}/tfschema --version")
  end
end