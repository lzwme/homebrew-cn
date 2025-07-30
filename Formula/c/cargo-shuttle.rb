class CargoShuttle < Formula
  desc "Build & ship backends without writing any infrastructure files"
  homepage "https://shuttle.dev"
  url "https://ghfast.top/https://github.com/shuttle-hq/shuttle/archive/refs/tags/v0.56.6.tar.gz"
  sha256 "10550369e65f964bb7bd86a6dd79090d7f0434601f665016882116eeae690272"
  license "Apache-2.0"
  head "https://github.com/shuttle-hq/shuttle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "30b00e05b0c3a4da68b43a9842de51ec2356895edb9bda699b45fb765e3830fb"
    sha256 cellar: :any,                 arm64_sonoma:  "e3b40f6dc2c2b8e26600955f3ee82a7d301f99a7b752995d4261a100e34f4147"
    sha256 cellar: :any,                 arm64_ventura: "7e32317f04d694559c036470fd3dfedfa309b2ba8c918cc7f76329296c8ecc13"
    sha256 cellar: :any,                 sonoma:        "7900b0c068ddbcb37f7b31c67b0555826a562534b8cb4b6839ca4f6af96ad559"
    sha256 cellar: :any,                 ventura:       "c9b51afc485e0a778e04a545be0fc923050929823ab063eb6919966ce55f3fd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd1bac5c670ce7df86dcebc3c354d02fc82dd7b845f00d2b33a940f6e1b6ccf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3983690938d13f3736859a96ad6d1b9dcc6cfca8c167d09872a0169f189ce7fc"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  uses_from_macos "bzip2"

  conflicts_with "shuttle-cli", because: "both install `shuttle` binaries"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    system "cargo", "install", *std_cargo_args(path: "cargo-shuttle")

    # cargo-shuttle is for old platform, while shuttle is for new platform
    # see discussion in https://github.com/shuttle-hq/shuttle/pull/1878/#issuecomment-2557487417
    %w[shuttle cargo-shuttle].each do |bin_name|
      generate_completions_from_executable(bin/bin_name, "generate", "shell")
      (man1/"#{bin_name}.1").write Utils.safe_popen_read(bin/bin_name, "generate", "manpage")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shuttle --version")
    assert_match "Unauthorized", shell_output("#{bin}/shuttle account 2>&1", 1)
    output = shell_output("#{bin}/shuttle deployment status 2>&1", 1)
    assert_match "ailed to find a Rust project in this directory.", output
  end
end