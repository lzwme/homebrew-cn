class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https:enter-tainer.github.iotypstyle"
  url "https:github.comEnter-tainertypstylearchiverefstagsv0.12.13.tar.gz"
  sha256 "79010e2d382f2d38020df6b34c4b0edb4aec7365b6819e66d6ac788ebf10a7dc"
  license "Apache-2.0"
  head "https:github.comEnter-tainertypstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3730f14c2a080f941e6a0d391432fbc9b95ded64f148d8f56df894352bc75604"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "487f540000c50a25c219f2cb4150fa38c067a7644231b49c02b84733b75ad4d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "afdb78d7312ffa843503c43d25a16be8f434cdbee36a3f3b4e7c2629f57d062f"
    sha256 cellar: :any_skip_relocation, sonoma:        "201f525d1d7aef7bb3accc607e5af4c49bc9fc936ee6d49627c462b0f6d32ed4"
    sha256 cellar: :any_skip_relocation, ventura:       "4121555a0f26630fe63614d9438db7df2c184692f1b06b2a47869800a304a181"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0a7e5fa26648a4586608dbf9d9b92aecc81d3d72b918d4d96c99da8e76624e9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratestypstyle")
  end

  test do
    (testpath"Hello.typ").write("Hello World!")
    system bin"typstyle", "Hello.typ"

    assert_match version.to_s, shell_output("#{bin}typstyle --version")
  end
end