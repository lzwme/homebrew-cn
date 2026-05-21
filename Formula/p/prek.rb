class Prek < Formula
  desc "Fast Git hook manager written in Rust, drop-in alternative to pre-commit"
  homepage "https://github.com/j178/prek"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "79aa52eee107e10b2d52baba6e7a52a7c3df2d13a2eb823211111a50927fe7fd"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c08e721cd02703c0182b7572abba589af3a60f48ca846de2514cb7576f233e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8da070397d0e92f3a87fb3080b84845a04a0d8e2811b3da16fae3870dc39c0f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba6915f87aa74d3d79f8495c7baf97550f5b436d575e69f4d6bfd9fe6585ad17"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a62ec762f492cb4bb444d84644e34b5e94bf0bb02abcad368fe53a36d4caf87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93eaedbfc162f04fd20fa43a3f728396bfb78e7d70002efdb59a8e2fc6d10c57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1148ee47ec4f8ec5632e8cd18c45f26ae8f8c275d82e2d76fb26dbc0b6d6d6e5"
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