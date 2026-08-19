class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/releases/download/v1.11.1/pup_1.11.1_source.tar.gz"
  sha256 "5230334c2e98b552189a2942758b7aaf8ff9b82ba4ca833e1ce57828033f8647"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "242a250021134a184adb38f2b93d67f8ef26d67bf20f6077b90b1b663521fe80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d4a872c3f0fd027fc50dff924ee1e877ed59d49c5f4dffcc5bc19fdd2808539"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b111a96a867684e77915e898caec49270cb789741f95f3d4ce16e66b41fdb443"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a70ea331fc74d3adbacf3de35c9b44c5905c5ad648748786843a97d176019e9"
    sha256 cellar: :any,                 arm64_linux:   "33953c9502388c68f2b8a8bbfcb38236f96bd8ffe4bd9ef4e999ce6337e2e968"
    sha256 cellar: :any,                 x86_64_linux:  "884767965e24002be934447d2c73c2f7c43503561edce893530b5ef41ec35c69"
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