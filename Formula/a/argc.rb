class Argc < Formula
  desc "Easily create and use cli based on bash script"
  homepage "https:github.comsigodenargc"
  url "https:github.comsigodenargcarchiverefstagsv1.21.0.tar.gz"
  sha256 "fdefde9388a19cc23c21f8261f339203c2fc2a7c9941709550c497a1cb0935d7"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01936b35118b90fec8cf9dde9b39a7ffce5e4f2c3fa5342d4deb1b17ea064be9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "371dbc627a41dd90cd22ae57335fb6b0d4ef96b930e4b6aa68d961539abdc4e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "48e7fadd19bcfb6ead4fb79c2dba92620c62d0ce8be01275efc2fcbceff527ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ed24925e4c6e5de7fee57aeeb304124397102893aafe24f245fb89a5427fa9b"
    sha256 cellar: :any_skip_relocation, ventura:       "dbd07cabfaaa014fbed24e4f2a9e6a5cbe3b249b54018d97251b562df057b9c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4038056ff409ebf860da659a54bdc5868a49a245c60c07baf0fd4cbdc348f25"
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