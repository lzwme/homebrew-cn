class Prefligit < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prefligit"
  url "https://ghfast.top/https://github.com/j178/prefligit/archive/refs/tags/v0.0.14.tar.gz"
  sha256 "5df1bb2c4b8ff1db4f7476e463d5e551cabca6221a91e4ed308b85e651ccfbae"
  license "MIT"
  head "https://github.com/j178/prefligit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abd29d15c5fe30a416e72b0e1e9b0ecc92f8a3d82ecbdbd740de2c9b13e0cfb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "391947b8f7c942c3f8044fb980eaee915b872d4fa15cfa12c56fed77d6c68c2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a61c2231732eff1f48a93c0964a3da4d81aaf6e34ebc782240edea59ce09b90e"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ece93d1218a7fe8b870f90a8c4c64b0803e30ee040b408d5ffa7d629bae9706"
    sha256 cellar: :any_skip_relocation, ventura:       "1d36ee986537e5b250afeaf3acf111578c0f4a0b0331bd78fadf4797227efc86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef8a81428a6c489e09817f670244dcec3d8643e635e9e03118b4a8253542918c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b143640d84b8dbcf068d87169ebaa100e18c695467c3a112cf43f0ef1a3b42e0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prefligit --version")

    output = shell_output("#{bin}/prefligit sample-config")
    assert_match "See https://pre-commit.com for more information", output
  end
end