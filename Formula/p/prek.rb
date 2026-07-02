class Prek < Formula
  desc "Fast Git hook manager written in Rust, drop-in alternative to pre-commit"
  homepage "https://prek.j178.dev/"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "7bfb877c1474df5c362a6d0ee5c0d32d072307b0927c64c8a600e8a24c80b66b"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f3aace763d5479df617ca9aade9ad486b1444cd7a273e259fcf1faa53a49904"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91cbf9c4de4667ce72899a0d7132a106b5777185927e386603b74fc3266bff80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ee2c25c84e5908042d6aeb3d0be36b8dcea8691faf67f7a8d777e43735c893f"
    sha256 cellar: :any_skip_relocation, sonoma:        "439097858dc2c9c06bcdff242e8c7ab388cfea2506b21ec105832075155c2fef"
    sha256 cellar: :any,                 arm64_linux:   "f1ef7f601225fe07fc8fa0cfa5b220040b2acc3d59c059c3dfb616f1af6eec23"
    sha256 cellar: :any,                 x86_64_linux:  "7ab6aec0d0f7b42970f54559a1025483e83076a2b8ed48e5369dd1538b912eef"
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
    assert_match "See https://prek.j178.dev for more information", output
  end
end