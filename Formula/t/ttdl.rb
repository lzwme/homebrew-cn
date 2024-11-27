class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https:github.comVladimirMarkelovttdl"
  url "https:github.comVladimirMarkelovttdlarchiverefstagsv4.7.0.tar.gz"
  sha256 "44a4e6e5405b8dc50438ebd77f321061193ad7c4265e765ee06f318ed1cedc65"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d306adf5dbeff692b71e43ab4a73ac2ccf9d2a224da61718eff1bd5af5a5e50c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "024af50ec7c64aa8b6d5c6982fa9eba1f74370710594a4b6984655efc8c93313"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a02311edb1e1fdd8d291a46c11ad32ca9bb054f69534efd99e11c974dae7ebb2"
    sha256 cellar: :any_skip_relocation, sonoma:        "6520ad58b759666b1a4e0a5e031a1c0167595fd8aa0032418b3fd3a85592cfd6"
    sha256 cellar: :any_skip_relocation, ventura:       "b055d677f287a900af32a150701cdfc6143fcfb64c75992e61ef328c8b544c1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "490ad0602fcc31a0c81505a52482e6856b82930039d5176fdb0f42605fc7f983"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Added todo", shell_output("#{bin}ttdl 'add readme due:tomorrow'")
    assert_predicate testpath"todo.txt", :exist?
    assert_match "add readme", shell_output("#{bin}ttdl list")
  end
end