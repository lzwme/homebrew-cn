class GoogleworkspaceCli < Formula
  desc "CLI for Drive, Gmail, Calendar, Sheets, Docs, Chat, Admin, and more"
  homepage "https://developers.google.com/workspace"
  # We cannot install from the npm registry because it installs precompiled binaries
  url "https://ghfast.top/https://github.com/googleworkspace/cli/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "1e9a1e4c33514673179a4f09511672caeef30d461506b7e2e398448cbd13e5bd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4fba771dd742e7fa46b2154bf52df5fe9533c84b308fe68525e59809a0eaeb83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "586bf364654093d5137e37539904a8b40b79b8310a8a9ca1077731c733ae787d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07bcfca487cb2001e2e4d1ef1468919a320e1b3bfe483e9899ac532556cf9a61"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb9b68275462374b24363405fdcf5ca8f6d71e477a3c8d28a09443f4e9e4d9ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab9fca826b45c815749c2036747e422d61a7fbdaa60bd8a27591e327f77c3441"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7a733bd06edc87af8175c4e401799a60efd7aaab9b857a8c8a648f5015589cb"
  end

  depends_on "rust" => :build

  conflicts_with "gws", because: "both install a `gws` binary"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gws --version")
    output = shell_output("#{bin}/gws drive files list --params '{\"pageSize\": 10}'", 2)
    assert_match "Access denied. No credentials provided.", output
  end
end