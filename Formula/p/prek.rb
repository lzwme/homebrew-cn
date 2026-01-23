class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "6e4e8c342cc03177d771f970cde99995387aa07694e8667e511f5e6c9adb0c02"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8bed51cc0a4b42d68d34cbaede663b2b78053e6671c94079781c2d52b22cdf9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45ce3347649da047bc3e8729f75862175b8d0b20e8e0259eeaf80f5495cb60a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91d147eb3ac41105e85fd14efc8e4f9343c4e37d0197c182a3e9088b29db3aac"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2f4d3bdf6366cbfbb3f30ebf41ab8c4f422dfeac3b05afa8e7dc5d63a142d87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80f88b2815ed4e4abc586c81611f3e94f2e3d719b2d1192ea543c4514306f17f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7ef073659c5bdbb5bbcfc2faff11e0ce9225ce14b092d258417d4f6e70359b8"
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