class Argc < Formula
  desc "Easily create and use cli based on bash script"
  homepage "https:github.comsigodenargc"
  url "https:github.comsigodenargcarchiverefstagsv1.21.1.tar.gz"
  sha256 "0cef31e887711e935083a99a01ce6d3b19bb02ea39bf4e010530c59dc607b164"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d5b77facc41271bdb15f7f40ec59bdb2a7639c2b318a730d0286881b2b8ab2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9ef935b89fcfc420b6c6da092d1dbe47f984c2c63e49e6adc715b82dbe62b52"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "35be90cec3b85e819702f5b9c33c4b8c7cc684bfdd35dae2c639d66eaa123886"
    sha256 cellar: :any_skip_relocation, sonoma:        "5394cd70e60ca547ebb6ae7452b01741fc7725f2c38dedb2c4d5bb8d6a38b30c"
    sha256 cellar: :any_skip_relocation, ventura:       "1d343ba577cf1606b73ae4d298c32eec914597fa1f7fa491b1091998598417e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f448c2f0435bbbbf6df7c7adb88a3575ef6d24a0ea794c23bc1ce0faf10008bc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"argc", "--argc-completions")
  end

  test do
    system bin"argc", "--argc-create", "build"
    assert_predicate testpath"Argcfile.sh", :exist?
    assert_match "build", shell_output("#{bin}argc build")
  end
end