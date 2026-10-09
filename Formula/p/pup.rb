class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/releases/download/v1.26.0/pup_1.26.0_source.tar.gz"
  sha256 "58b35930b07faf6cc93b13b852883a37ef9f5f507b01b591649cd20fb4e0ca1b"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bc08f68ee6fd66d4c1fc562f4793b0521a104cbd4700f7d675ffa8a4b02fe30c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7190638a146546a97a7eb2d5a84974e7a77d0db63ef48dc6b8454c37219d4716"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e98ab2f6f2ad29c4c3ea92230ba6307ecfcd5507d8d146e44a7d2f1723400dbe"
    sha256 cellar: :any,                 arm64_linux:       "014a42552c1024329438494359ca01579d2db8490decd0e4ea0e92393fa1153b"
    sha256 cellar: :any,                 x86_64_linux:      "e715e671f68df162c4b9329a824f6566ae2378fa2014e135d75beb6d98d7183a"
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