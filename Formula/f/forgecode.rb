class Forgecode < Formula
  desc "AI-enhanced terminal development environment"
  homepage "https://forgecode.dev/"
  url "https://ghfast.top/https://github.com/tailcallhq/forgecode/archive/refs/tags/v2.13.15.tar.gz"
  sha256 "5020fbf5fb7c502e29b814060726e28b6624b920b125044afd384ec5121a6c46"
  license "Apache-2.0"
  head "https://github.com/tailcallhq/forgecode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d598411164f06ab5a80a8a8ce96bc6430e88d739d89b122e698d7208c75cc36c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2319c47f4a569bf6392c9ac52137c9c1aab406e42bb7eb9fc99caaf96a7acdb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f374ad253f61d49085a08235126eb55b78b28f7290fcea7b2540c194b246b321"
    sha256 cellar: :any_skip_relocation, sonoma:        "548b00c9019d74826df640c6899c3ceb4aad194bd4c153c38054c48bb15583e6"
    sha256 cellar: :any,                 arm64_linux:   "c51a7e69e029f5e82c44be1c36b50ae4d497e0131af384f4c0ac31d660c61252"
    sha256 cellar: :any,                 x86_64_linux:  "eb782643501fe47184e8e04bf90d36fc31428bf219316ecb16cb6bc7966c0168"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    ENV["APP_VERSION"] = version.to_s

    system "cargo", "install", *std_cargo_args(path: "crates/forge_main")
  end

  test do
    # forgecode is a TUI application
    assert_match version.to_s, shell_output("#{bin}/forge banner 2>&1")
  end
end