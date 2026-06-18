class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "cd5dc4e7618cef90cbe3ac72aaa784027d92fa7e5dd45db75648462f27e76eab"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f6230f118ecf200bd60695fb1829bc34e27cb39b01c7594ac3992844ad47240"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8e7a194c1c1140d813d33b6822728a55a3f5286d48feb1c9072aef2ebd7ac2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1f0267bb5a0acc504a414bf594bec63e7672cffe869173d138720abdb8c3821"
    sha256 cellar: :any_skip_relocation, sonoma:        "f40adf1f379a58d6da56c9d8ba67769a8910543f4f159e39e576588892137496"
    sha256 cellar: :any,                 arm64_linux:   "a2df35605df655d1aca3ea37bcf355e3ad0336ab0d9f85b1d6bc77b9ddf36823"
    sha256 cellar: :any,                 x86_64_linux:  "a1ebc3f6dc8b23bf7c5bee667a4075d37bbcb3e86f3ddf74beafafe722f4484e"
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