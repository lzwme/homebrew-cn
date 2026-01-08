class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.2.27.tar.gz"
  sha256 "838a45715a7eeefa521796fbe24b8d1566510667ced40f91b4ab5500f02b0c7f"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87a9559f78eb284e06b5631aadfb8d6bce610bfa7f8be72c1bb1d89be8181908"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17167690e9a9a0312d4b3fcd5a400fc541cb497d2dbb942f3526ffefb6feead6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1bd1c5ce3777a56ff6adb39edde6bc02c8d36156210ca9a7fadc7075489da9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e85a18c33a846366dd0c6c0748432aed59c360fd35a2db1373b583d02ee0a92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a044da691ee91829741e8862884f2e5c0c2aa4f7ebfd15e63db23ad50fd6cdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47195009803b3847f534b721aba2e9e691422b7823e6819fca3d2ef5f6b3d938"
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