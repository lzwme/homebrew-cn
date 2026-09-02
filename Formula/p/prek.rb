class Prek < Formula
  desc "Fast Git hook manager written in Rust, drop-in alternative to pre-commit"
  homepage "https://prek.j178.dev/"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "df9acdbaef7525639020a541ebc38943d50b6ddb71724645e4af31f8a260536d"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73b6a82838476e737a1a48d1e65411d1b972563e6cad1750a47df30c0f4f19dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71305d87058f0e15d9178dce219aa695508a5c931ba2e27ac5acc72935b1b7ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4c653c1dfe6fb453c0458c503708b57e6ea170c518dccb7ce195758210de662"
    sha256 cellar: :any,                 arm64_linux:   "faeba49f0c698f611722d88ae8c4e39e792d399bee827401fb822b2668a66ccc"
    sha256 cellar: :any,                 x86_64_linux:  "c739b63f01774aa8325991a5572be5818dc7a19cdbc966b7795e193a8f0a4187"
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