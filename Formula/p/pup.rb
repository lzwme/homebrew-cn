class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://github.com/DataDog/pup"
  url "https://ghfast.top/https://github.com/DataDog/pup/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "48aff94f87a4682ae6a4f675745cb3d9aab9b59fe3ae8aa857a749788fb915ce"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2735b7507d9ee44f57f8c2e8fe0be6090a67c1a0e026582d86b4168cde9a7924"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1198a2e46219fc4c27524ee8323718f9af106aa9a8c253c4846cb4971715136"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd8eaf28c9d214992f7535e3ddd0a974597623d2834bb38c1ae1ab0654d2fa6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "13d771b10ad1a1a2ae5d7f44ca30c74b65443465a464fba98c250ed22625b9a7"
    sha256 cellar: :any,                 arm64_linux:   "9199f62771bff8ce7dbe0c02f08d2ab74cd92f9e9f1dac6e0cecb03232a56d65"
    sha256 cellar: :any,                 x86_64_linux:  "c5a52975e68237ca147511ab1702b2f15a4f279509b4f3423430b28317b70e99"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pup", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pup --version")
    assert_match "Use pup CLI or generate code", shell_output("#{bin}/pup skills list")
  end
end