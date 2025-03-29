class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https:enter-tainer.github.iotypstyle"
  url "https:github.comEnter-tainertypstylearchiverefstagsv0.13.2.tar.gz"
  sha256 "0b40fea5ac607ab9613a2640ae1a6a017bb41f753c4cfadd236cfffe37f0fa86"
  license "Apache-2.0"
  head "https:github.comEnter-tainertypstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11ad6cc604ebb111629471181689a2bb672d39445992008ca6d7e06e57292356"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ceb24fff1a87eacf3a632f297917e8929fba9689fd6852107e0b226b8340c39"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b47f1cf7ce47ef0055d9268721eaa80b862405a238491b724e5a3580f60f1083"
    sha256 cellar: :any_skip_relocation, sonoma:        "208e8571de69fe5c3fafa0494e46113bdcfa0f71f8cc206338e8b820d0a80aba"
    sha256 cellar: :any_skip_relocation, ventura:       "6fd84beb39af77edf2a2ca3870ed7315a4ecfaa403ccfcfa141e9a122de47545"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dcaae35b6ec2cac153282f822512ecba905ba2f58fb998896b58e050ca28914c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b18ee9aea6a4c03881494b8751b36751e76c4490f1ec011c69b093d42867acc8"
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