class Cotp < Formula
  desc "TOTPHOTP authenticator app with import functionality"
  homepage "https:github.comreplydevcotp"
  url "https:github.comreplydevcotparchiverefstagsv1.9.3.tar.gz"
  sha256 "17db3320e856681014e2feeeff25a49a0f06c2686ce264058e2f1d0294d55697"
  license "GPL-3.0-only"
  head "https:github.comreplydevcotp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83e5dd05c109565cd3239eb5a3388b5c56a8389ea38a1673615082ac87d010e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17114e7089724fc2c0854dc358f2e8d7fda8435a31b857505d82b014e8859b0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9bf26d16e4dea7cad01a1ea4506a4e3e755546ec5f9105a8522cf7b489d3409c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cd96c7073add793ceffc2a98b68a3a7c9a1dbb298c4d94fe1f2dcdd6521dd80"
    sha256 cellar: :any_skip_relocation, ventura:       "0cef315a17d082fdf0e725bf44e2fb94f7fb74d8222758a2088870850b70e9df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58d4017bc993a953f289b59c4897f7f95d082a1bb7c67a77a8e41979b0511b58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cd1e46054bc8dbaf35265ff52c44cf740383746546cb2b0e047361bebbba0ab"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Proper test needs password input, so use error message for executable check
    assert_match <<~EOS, shell_output("#{bin}cotp edit 2>&1", 2)
      error: the following required arguments were not provided:
        --index <INDEX>
    EOS

    assert_match version.to_s, shell_output("#{bin}cotp --version")
  end
end