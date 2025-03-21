class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https:github.comalexpasmantiertelevision"
  url "https:github.comalexpasmantiertelevisionarchiverefstags0.11.0.tar.gz"
  sha256 "a1a3f68850ae23436f9790966b34401bbc6cd83f00d33a003e88ce8ae5b24847"
  license "MIT"
  head "https:github.comalexpasmantiertelevision.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bb44fc63682e0bce35c3d4eb24310a0fd1255f5cef426d94fd8595c032d0db1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67248a65a26107bbe8bb4630e484f88011028522108724444d2479cd3e1e5b39"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b9b835246064bbaa40f689e6826e6b68511d5bf3800363659e35ebe183c36d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "0757b286f3628a67dd48704fd2ec01e5515316a574c528e362c0fb999e9a74de"
    sha256 cellar: :any_skip_relocation, ventura:       "80e62d8024c1740995b3f549eaac818ae0d98744933d813f75c85dfae8ead9bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "909129de3f6819f8cfe3ae5d9263ba32ce63843ac5a3a431ca9e63490d4fbbd8"
  end

  depends_on "rust" => :build

  conflicts_with "tidy-viewer", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}tv -V")

    output = shell_output("#{bin}tv list-channels")
    assert_match "Builtin channels", output
  end
end