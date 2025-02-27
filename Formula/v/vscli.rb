class Vscli < Formula
  desc "CLITUI that launches VSCode projects, with a focus on dev containers"
  homepage "https:github.commichidkvscli"
  url "https:github.commichidkvscliarchiverefstagsv1.2.0.tar.gz"
  sha256 "5d3eed6c34541fca9f98d766a94b287f648af43d219d68e8546f9862abc34259"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7c075db90e8c2d6a452882b22ee9bcd0cf5982aae60c86e5c26b0564b50d535"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "827740cead93055a587501613a5ee3a96e09a142d33a3be520d2a89cbfc7c856"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9eae28c580f3823adf4dc5e35e914b087a62738dea0451937a8dcdd04c5a98d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "87fac2025b44db077d1d81139a159b7cb7bab01be03feb53a10b06bcfe76ffe4"
    sha256 cellar: :any_skip_relocation, ventura:       "bff70db8826ea88914067619f660bdb5aee3f0e9db34487a4810e88d8997e565"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2983fb995eb3a50c2625eeb980831fb431e6201929f8deb8e48b6ed7800e95a1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}vscli --version")

    output = pipe_output("#{bin}vscli open --dry-run 2>&1")
    assert_match "No dev container found, opening on host system with code..", output
  end
end