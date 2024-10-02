class Binsider < Formula
  desc "Analyzes ELF binaries"
  homepage "https:binsider.dev"
  url "https:github.comorhunbinsiderarchiverefstagsv0.2.0.tar.gz"
  sha256 "f6792950c77795485414a4e82fce7898debed271a4d6fc6e509dc9bfe7879e72"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comorhunbinsider.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64396fbb1c6e0860d5d79aa86820ae8b2bb5f35195a1b440af10a59e2f89f4b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e8a90f19ab27480bbf7fbf38db0eaa1253c7b026d607792ef8af29a7aefde94"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "79279a89007e958b047a8067dd640931b303ac1f4c73556bdf2fbc26b8258719"
    sha256 cellar: :any_skip_relocation, sonoma:        "37802739bda335014bf87fd3550e7d78b7d1a6fc642f34771c650988fd1934ae"
    sha256 cellar: :any_skip_relocation, ventura:       "e5b66954f76d99ac630bfcce0af22b15a21879a1b4edbe65a0288eb51294bffe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06379f6228b7fcd71be830e3f876fee8fd08c3806c17f51d6cbd160cc1fabda6"
  end

  depends_on "rust" => :build

  def install
    # We pass this arg to disable the `dynamic-analysis` feature on macOS.
    # This feature is not supported on macOS and fails to compile.
    args = []
    args << "--no-default-features" if OS.mac?

    system "cargo", "install", *args, *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}binsider -V")

    # IO error: `No such device or address (os error 6)`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "Invalid Magic Bytes",
      shell_output(bin"binsider 2>&1", 1)
  end
end