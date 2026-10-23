class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/releases/download/v2.3.0/pup_2.3.0_source.tar.gz"
  sha256 "51364c859417eb2cc21f6a5da64d87dd40c7fcdec6fd8a51d94b201ea7f05a3a"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "441d56e0e52e68aade569f16cc1984dc7d2ad72d12b6ea5a857a36ac2dc973e3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "13d28a1d067f26b1c61afbef518daf5bd91594201e257e01a65d259d90660eb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f42babdfeab40e03e170101ff8b811cc59e1e4b6eba3281b97bca824906ea448"
    sha256 cellar: :any,                 arm64_linux:       "3660f41a3fdb20d9325df53deb3e32723d5d8e2fb9f16c4a151040a2b6488184"
    sha256 cellar: :any,                 x86_64_linux:      "7a169d56c9bb29969fb59b21f7ae39eedfaca0ff6b5b14eae247e4eb7bd18b8e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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