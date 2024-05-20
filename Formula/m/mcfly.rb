class Mcfly < Formula
  desc "Fly through your shell history"
  homepage "https:github.comcantinomcfly"
  url "https:github.comcantinomcflyarchiverefstagsv0.8.6.tar.gz"
  sha256 "baab80d9c78843d32a04d63107ec4fc8d7627989ac374bd16a2a9904f296498b"
  license "MIT"
  head "https:github.comcantinomcfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "18892a398b5698dcf71503c2b3648a5309dce2cdbadf7c05d3d8ecc2583cb260"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3e5a8161935f99dd381772b0f405bf942d8cda981dc62fccd80684641c2a3b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "849e4db62339944d0d5b70656904adebd955a5698bb694a2fc4f17774f41cded"
    sha256 cellar: :any_skip_relocation, sonoma:         "1145862c37203909ab7bf58420531f6f2f19217f98aec1244efdaa551d6ab8b4"
    sha256 cellar: :any_skip_relocation, ventura:        "09d81756c91eadb5fab426449941ff85a351a6b0800b56820a425449f551f46c"
    sha256 cellar: :any_skip_relocation, monterey:       "0e848ed753e5f02ab38ec56a5b3fde085a933a7b110394b222f914bae1104e52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7310a5607e1067771457ef0cebab5b540d67a3c0bf6b102e8854f1e4b47dc31"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "mcfly_prompt_command", shell_output("#{bin}mcfly init bash")
    assert_match version.to_s, shell_output("#{bin}mcfly --version")
  end
end