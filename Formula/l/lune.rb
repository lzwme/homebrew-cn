class Lune < Formula
  desc "Standalone Luau script runtime"
  homepage "https://lune-org.github.io/docs"
  url "https://ghproxy.com/https://github.com/filiptibell/lune/archive/refs/tags/v0.7.10.tar.gz"
  sha256 "e3851ba897f568a9fef2014b8d06f9b4c0df74d5d64b5e8aa2cedde35334507a"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da822d8f7bf20bec015a5857cd80eac477b224fbac56a03ec4992c2ed31e0c54"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08943ad8f561e1caea04fdc3b3e468b55aada1fb2f84919d4c2e0982c070aa41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c68ae906e3856527053a04df307afe10d5462f127da70af20a23afca515535e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "29d6c4d9f58f9e73813fd0f95f504d86fd1f847a786c1080dea03354e6d971a8"
    sha256 cellar: :any_skip_relocation, ventura:        "3b746dbaedb00db3fff230257365aa44e946ba4d9372c10c84eff2f0ae82b527"
    sha256 cellar: :any_skip_relocation, monterey:       "fd75efd0673bbf255b41bf502b6e49cba539926831e5f5cb48c32a3d07313561"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e45d97cfab414bf2fff57731af19673ba9bc7469f16388eef93c6a88c910f28f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--all-features", *std_cargo_args
  end

  test do
    (testpath/"test.lua").write("print(2 + 2)")
    assert_equal "4", shell_output("#{bin}/lune test.lua").chomp
  end
end