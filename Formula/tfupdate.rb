class Tfupdate < Formula
  desc "Update version constraints in your Terraform configurations"
  homepage "https://github.com/minamijoyo/tfupdate"
  url "https://ghproxy.com/https://github.com/minamijoyo/tfupdate/archive/v0.7.1.tar.gz"
  sha256 "8f7952175e96b226c19ef615fe1a49c725585c4265c4e8121434e84d2a1f1f51"
  license "MIT"
  head "https://github.com/minamijoyo/tfupdate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0135b5ecbc12cf0bebf6061e0ef5d68067b9d0a401ad4689f9982542d095074d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0135b5ecbc12cf0bebf6061e0ef5d68067b9d0a401ad4689f9982542d095074d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0135b5ecbc12cf0bebf6061e0ef5d68067b9d0a401ad4689f9982542d095074d"
    sha256 cellar: :any_skip_relocation, ventura:        "f1ce4df587f96559ab8237270b591ea4ee95e87899ac757604304f67a3302f4e"
    sha256 cellar: :any_skip_relocation, monterey:       "f1ce4df587f96559ab8237270b591ea4ee95e87899ac757604304f67a3302f4e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1ce4df587f96559ab8237270b591ea4ee95e87899ac757604304f67a3302f4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01b2fc533f51ec23b798a190936f9d544b8fae9d850ca48ab6de66b6a22bb0db"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"provider.tf").write <<~EOS
      provider "aws" {
        version = "2.39.0"
      }
    EOS

    system bin/"tfupdate", "provider", "aws", "-v", "2.40.0", testpath/"provider.tf"
    assert_match "2.40.0", File.read(testpath/"provider.tf")

    # list the most recent 5 releases
    assert_match Formula["terraform"].version.to_s, shell_output(bin/"tfupdate release list -n 5 hashicorp/terraform")

    assert_match version.to_s, shell_output(bin/"tfupdate --version")
  end
end