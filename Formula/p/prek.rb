class Prek < Formula
  desc "Fast Git hook manager written in Rust, drop-in alternative to pre-commit"
  homepage "https://prek.j178.dev/"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.4.12.tar.gz"
  sha256 "e2744b62521f1dbf080a04270d41609c45a279ed028c3d083b1ffdcf52de6219"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e96bb3a55dcbd52027f2fcd7826094922f15f7d1da0dcf1a51e47667a1d1c23d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bad815df4981100b47ee1289206b2b885eff440b33daebd2b737d2fb2f583eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c5d48fadd34f78e438908c823c4aa217200085a54ccd1d1ad8a9dbc549cb830"
    sha256 cellar: :any_skip_relocation, sonoma:        "e30c0cc29c1fa007e83e73251e14f9b8db6092cc619adba63343ca014d0ca5da"
    sha256 cellar: :any,                 arm64_linux:   "a775c6d6110472132105b3c781405e373b6e331cd0a96473f127dbde16e59e7b"
    sha256 cellar: :any,                 x86_64_linux:  "37da431ed5b220c089176d4ea9da7e403c917e93c2a25b8f72f8aba19b904e89"
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