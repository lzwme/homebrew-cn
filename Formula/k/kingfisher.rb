class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https:github.commongodbkingfisher"
  url "https:github.commongodbkingfisherarchiverefstagsv1.17.1.tar.gz"
  sha256 "815e181648695f9ed23ae9357f6cc487c79d02f25c0b858098de611ccc7302e2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e362d4079c66171385566ce9e10aa83cd382a76530ef1d8ec9545c48b0e09942"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab03bd13a8d29df96db97b449b408fad22e6dbe132ea7f965d2f151c07c79082"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ab2ce56fc3118303e2d869f3b56555714a8e155ac9f0aeb7852f48446494c563"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcb49530a257f1c42b45b54d5d2424efc722e874a7008cd850376a868dfb5491"
    sha256 cellar: :any_skip_relocation, ventura:       "2b29c1b60c33ea0c23e8ff9a61c7856f86ad818effd46e6935bb16a82bc545f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a30740d9ae91afdc4303075e6df7bafb28dcd44bbc2b9d82ea2a7722856e0131"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "275d2235c86b98a75e638ca32a8134af6a916871dfc48f4e5ccb01c1495cac34"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kingfisher --version")

    output = shell_output(bin"kingfisher scan --git-url https:github.comhomebrew.github")
    assert_match "|Findings....................: 0", output
  end
end