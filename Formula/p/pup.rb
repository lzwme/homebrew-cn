class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/releases/download/v1.21.1/pup_1.21.1_source.tar.gz"
  sha256 "e04d519f8d7c24299dfbb704d0ef358a765aceceeb46c32af2c80290022b0b67"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2002577d80e01217a7adb15b4e76e7a7ec6fbca39ddf978546137ff690fbff6a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8ac92045003946258e873fa57d3389997523c907706aaa6a2e667d9118f211de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c40db40887874c95ca42e8fb17840247a78077d5866fcffd430ac655145e02c0"
    sha256 cellar: :any,                 arm64_linux:       "1a0bd2d00c42774a7b1a9f7a683e55c1baf89cfc8df8da07b58310e5b9f00365"
    sha256 cellar: :any,                 x86_64_linux:      "47efd5dcb51c8cdc1adebaab445bc59541b928e0566dc4be065664d89a9fbf29"
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