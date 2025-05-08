class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https:enter-tainer.github.iotypstyle"
  url "https:github.comEnter-tainertypstylearchiverefstagsv0.13.5.tar.gz"
  sha256 "8d152334a41c9c1b0668c765e9713b5454f8db5eada02a3a32fff93753508579"
  license "Apache-2.0"
  head "https:github.comEnter-tainertypstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb73ba2633000a83b7adca1dcf76e94e284d9639d5e6247ea636d554f3a587a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c02bf966d290d9e9022168b4b834065e94deca2d3b18cee72d5a54b862635453"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "63a58357f91b686dcc256fe954eb9b9395fbbc7d95d477e8ae4bdfc66a7918cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9328898f04b2c545306cc942392545498e6102efd4732f0bb36c90166a58cd5"
    sha256 cellar: :any_skip_relocation, ventura:       "15cc042fc3fb2402f8df1db6b727f513012d200193615f5fbc60198e0ed0ab06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fea3705566ef8c2f998df4a93be67a0c209ac95f2e5e363e58cdb80e5d9aec99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8dc133a867428cd587bca4598c04932a95740ab7c892dc285da8930a6148bfb6"
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