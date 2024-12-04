class Nickel < Formula
  desc "Better configuration for less"
  homepage "https:github.comtweagnickel"
  url "https:github.comtweagnickelarchiverefstags1.9.0.tar.gz"
  sha256 "c5c0000e6b1618921c1ce23dc90eefb482bdfe9f9716d4ef5cf24a3b99ec4c7d"
  license "MIT"
  head "https:github.comtweagnickel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "506125955cbbd70f1674454cb727c2a3cc5ecda34a83550bb0846846a536ecd6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49b0abfdd487f8a155eb10496e0627cc60337143c66dec5f883b2e46736eb23a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "54238f41a2b7cccc2e38854dfa2e2b71c18b8467e3bc8a47ed755c59dbcd4e44"
    sha256 cellar: :any_skip_relocation, sonoma:        "56618f2098ff20ff4f358fb09b4da1d367844824ad5d19237268cb0d965ad1a6"
    sha256 cellar: :any_skip_relocation, ventura:       "5aab1d707c105c2bf6ff3518ea9215a981e70eea49cbe3fda8297c6e5ea3e7bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92cab7bffd980ed4ab4987668fbed7e738c0476d793d0745c9ccd78e236d2e4b"
  end

  depends_on "rust" => :build

  def install
    ENV["NICKEL_NIX_BUILD_REV"] = tap.user.to_s

    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin"nickel", "gen-completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}nickel --version")

    (testpath"program.ncl").write <<~NICKEL
      let s = "world" in "Hello, " ++ s
    NICKEL

    output = shell_output("#{bin}nickel eval program.ncl")
    assert_match "Hello, world", output
  end
end