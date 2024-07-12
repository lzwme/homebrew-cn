class Mcfly < Formula
  desc "Fly through your shell history"
  homepage "https:github.comcantinomcfly"
  url "https:github.comcantinomcflyarchiverefstagsv0.9.1.tar.gz"
  sha256 "3f2f7ff1d8c4ccf5e7f98b185723c415a38883068cb8533ddd551ed4a8f059e9"
  license "MIT"
  head "https:github.comcantinomcfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "63b7c2d3d5bf59c4553917a45a59fef1755f7a07846dd3b7c6118e3c66725ac3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc9ee8537b0fbfcf91477802c6b95319a7d22d42f64e4764a41edec9cfd9904e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66cdcb54ce07e32d723b254f28edb7d9c0c2730e1853bf3d664ef00eb4681d81"
    sha256 cellar: :any_skip_relocation, sonoma:         "79cbf318f882a393b241c506fbce4639bb14f2da03b9864c4d687785c0e130a2"
    sha256 cellar: :any_skip_relocation, ventura:        "f28b2d4ddddb3c0efdbadb9daa564fee476e86d94c4bc01965db82757a774517"
    sha256 cellar: :any_skip_relocation, monterey:       "8c29db42d0a022141d9548db7b1657a8e657ba474a2ad0ef2da1bc6903938a03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "044d160ca6d8ac6b031a395eddb07635893703a2c5427461e65c1c768758ac55"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "mcfly_prompt_command", shell_output("#{bin}mcfly init bash")
    assert_match version.to_s, shell_output("#{bin}mcfly --version")
  end
end