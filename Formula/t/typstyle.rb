class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https:enter-tainer.github.iotypstyle"
  url "https:github.comEnter-tainertypstylearchiverefstagsv0.12.13.tar.gz"
  sha256 "79010e2d382f2d38020df6b34c4b0edb4aec7365b6819e66d6ac788ebf10a7dc"
  license "Apache-2.0"
  head "https:github.comEnter-tainertypstyle.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cec5051403900129db4d5984fc81f8a78f2c359cd1b8fdcbf072cc4df780b72e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0dd06f0f72994c1769373fc076af022bf70bc3e1761dc2560d2b11a7603a982b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "95f4ae101b7f5cd7479e54c39df81e1fcb8bac8c097a7a645f33dd4fc4b3c816"
    sha256 cellar: :any_skip_relocation, sonoma:        "585625f09b16dbde53858014b16a8c6cd7010dd6802c092b9c2d394d12b635c5"
    sha256 cellar: :any_skip_relocation, ventura:       "b72df48eee1a1ee4131dc75f114a5e54607e2bf034728993f5d3cac55ed43f1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b55f8bb1b80f76be191550f8bfb50ee42fb340ce12a783515b9e6b657b8f3674"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratestypstyle")

    generate_completions_from_executable(bin"typstyle", "completions")
  end

  test do
    (testpath"Hello.typ").write("Hello World!")
    system bin"typstyle", "Hello.typ"

    assert_match version.to_s, shell_output("#{bin}typstyle --version")
  end
end