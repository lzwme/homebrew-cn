class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.2.14.tar.gz"
  sha256 "acc7e01ff9bc7a30732f69f479a16437eef5333d2f98203ed351ca5075f4cdbc"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a89680fcf28fab619c53c8d652044d0afaa3eb3b37aba64bb25ffbb5008d7bff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e145f1f0811625104bbee611529dd9489810da8534c1dcaf9bff1c4ecc6ef6d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6c83e3ad7aa4cabab64c9e345ca02fa10726394311a5abaa887af1873d18c77"
    sha256 cellar: :any_skip_relocation, sonoma:        "58172ad5feb05e12716a8d852f0303a767b777535a45c9714c2f9984e7a39a23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc6919420f932fe25fe48deca79ea5752a9d3d6876a64cfc4f630ba3ce3a3280"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e98771711bdc2a2d7a8e9c11372a32dad56fbc8eb3c8e3abe79d04123e8e1ba6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"prek", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prek --version")

    output = shell_output("#{bin}/prek sample-config")
    assert_match "See https://pre-commit.com for more information", output
  end
end