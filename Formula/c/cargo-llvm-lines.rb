class CargoLlvmLines < Formula
  desc "Count lines of LLVM IR per generic function"
  homepage "https:github.comdtolnaycargo-llvm-lines"
  url "https:github.comdtolnaycargo-llvm-linesarchiverefstags0.4.41.tar.gz"
  sha256 "4674fd81bf3c565fd19e6405e4fd2cd65b2e7c21ec06da762b148150ddcb2787"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comdtolnaycargo-llvm-lines.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9900e26c5651c6e8d24680c25d1efcb3d4fe14576aff26dbbd09d1b2c443a59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f25e56422803cd44cf091afe47337009c1852651c09a8da6bf8acb44d8b0253f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f353796bcf6f188deff4b05d489cc3f4d216441849c0cd07f272d6a9a1b188d"
    sha256 cellar: :any_skip_relocation, sonoma:        "72ee668391a3bd302728779cf0ceac504c0b38e73480c9d54a96b3657b31bfd7"
    sha256 cellar: :any_skip_relocation, ventura:       "83f802477e53e768f455dd060ab63cb15bb5c9f299ba68676f8322bae7b412a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fff265422209daaaf26634109a1eaeff1ed48a55fa6f4657016a01d211038ebe"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https:github.comHomebrewhomebrew-corepull134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      output = shell_output("cargo llvm-lines 2>&1")
      assert_match "core::ops::function::FnOnce::call_once", output
    end
  end
end