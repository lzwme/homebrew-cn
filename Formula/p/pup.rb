class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/releases/download/v1.14.0/pup_1.14.0_source.tar.gz"
  sha256 "75a4bb01ba39f138ee536dbe80ab0d762ce31ddb504ae67f8cee9057094274d2"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f74198a627de4134102f239e169bc2c9d124ed13c3b5bb7e6ebc9e224b4012f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9da3410c854ff3cb404f3f606b79550c9494f6f9cd357adfcc3f2a9ba9151468"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebd97a861684d16cd6da14713ca0e5f40416966681c49fd7f04c932ed27c8307"
    sha256 cellar: :any_skip_relocation, sonoma:        "11581fe6ab54af73ae38bbb8c2263dc0499a8ac91635772a9c7c4512e5290554"
    sha256 cellar: :any,                 arm64_linux:   "9dfd4ba33a7967d74cc9fd0082a0a77f7dbbead311337804818362c1afd63569"
    sha256 cellar: :any,                 x86_64_linux:  "0a744916f070d3aaeabd633f3890a6d1d585359480ba180d08053550195cb11b"
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