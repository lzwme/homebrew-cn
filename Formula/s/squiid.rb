class Squiid < Formula
  desc "Do advanced algebraic and RPN calculations"
  homepage "https://imaginaryinfinity.net/projects/squiid/"
  url "https://gitlab.com/ImaginaryInfinity/squiid-calculator/squiid/-/archive/1.2.2/squiid-1.2.2.tar.gz"
  sha256 "75b2ac5526878aa49aa97c63f7041796768fcfc3a7c63e3692fa65648ea5ebfc"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4980cdb46fcc13a66bfebd3bb71b629872ac9b7017a04f643034cfa4140918ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af984d37f42aff9d81eec6bc4fa03261c4eff91dc0414696796c79ce8230e74d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8258de8e85577ce62b5fd983e76a17be11b648f96ef1e4c4c395fe95c5cee972"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e11ef4bde72599945c4ed5b969e78d7cec2fde57342b5cd9c9c52e8fba9d419"
    sha256 cellar: :any_skip_relocation, ventura:       "cb1dda1359f08c4c26f20a9a6a8413610a8c4e95ca4f7b0754636358ff41813c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1b8f6f2d75f0b92ca66d8e1e2382dfce20e43155f4237a87fa244edce89bdc2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # squiid is a TUI app
    assert_match version.to_s, shell_output("#{bin}/squiid --version")
  end
end