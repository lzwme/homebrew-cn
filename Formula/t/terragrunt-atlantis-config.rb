class TerragruntAtlantisConfig < Formula
  desc "Generate Atlantis config for Terragrunt projects"
  homepage "https:github.comtranscend-ioterragrunt-atlantis-config"
  url "https:github.comtranscend-ioterragrunt-atlantis-configarchiverefstagsv1.17.3.tar.gz"
  sha256 "d8e9542e5dbd3b2cade1bd66c0cf16c347b9fed8f73c3621fb7c11824a06ab9b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b21bdc8625a5b520ec9bc6f3a485f62c5aad5e4e5f51e4052126a779dcd51337"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7aed9736564832c0334acc6c2366d85a9e9697412278c666cd5d2f0541f7d0eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbb9a2e91e724a9f6112ebf601f6dad6502a97daec4584a2fc0d3ddad7a41414"
    sha256 cellar: :any_skip_relocation, sonoma:         "62463f8730bccdc0883e2663492cc6b3079cd26b66e42da829f0c11918403495"
    sha256 cellar: :any_skip_relocation, ventura:        "7de1f5ee982c2c01a52ffa507c389940c5d81277c63be58b0e0efa1e1cc94ac2"
    sha256 cellar: :any_skip_relocation, monterey:       "30c1ed19a3ac635bf363bf795e924ab6c527aec969e372f2e2607e4842a6f043"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "443b6e4b1caa74bdc60f0da9814f70e5670b8f80b9aa95a3f63588a038e43c6a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}terragrunt-atlantis-config generate --root #{testpath} 2>&1")
    assert_match "Could not find an old config file. Starting from scratch", output

    assert_match version.to_s, shell_output("#{bin}terragrunt-atlantis-config version")
  end
end