class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "1e17e690d65b8d84b9d23adff8189a6b0667e3484d65f5add0acf7e8a787beec"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "623f404f92d8cf03b381771cb81c23c66096173da1e205fb3205bb9c5d478747"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "508616f93943f1d39cce127c6cdaf0a51c64659999a55957e5b1f8e8808e8756"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9a48b3fd4d1812fabd1674b0f04a6cf2f19ebfccf8ca0c0d9257286f812e2b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f681b6731e67983e3adbb389436137941ec469ea88ae241d7e2c3397109f403"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fb80328449ca78c920bdfa6de21cc0712044933eeeb10fb933ed9f5726793d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5f2aabc174f4befc7073fdfe6dace1ff73dbf48defb40237d8d4346654a3f0c"
  end

  depends_on "rust" => :build

  def install
    ENV["PREK_COMMIT_HASH"] = ENV["PREK_COMMIT_SHORT_HASH"] = tap.user
    ENV["PREK_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", *std_cargo_args(path: "crates/prek")
    generate_completions_from_executable(bin/"prek", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prek --version")

    output = shell_output("#{bin}/prek sample-config")
    assert_match "See https://pre-commit.com for more information", output
  end
end