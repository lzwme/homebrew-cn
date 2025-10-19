class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.2.10.tar.gz"
  sha256 "92c079d2e8549a6d13320c92e59b3103f508356c5731770dc78cc875e1645fb6"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "722a784ac737598952c8f770c23a29c71c2d12b5f06ba5c3d1bdb57de8015bb2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1a14a3e487b9117185cb2d20723acf83f9f47383ef87cc1d241cd89df5b1fc4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a0793277c595aeb62469fe3a3d97191c9639ddef00dfa3a7c3652069c030969"
    sha256 cellar: :any_skip_relocation, sonoma:        "50fcabaf28be4d1f4ee8693aa250759fcffa9daf460c66c267f822e0912d3eeb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cee26037ac9c20b399c31dffeb23bcff78ea223b2a2d05edf332b5e8b2ebfaec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b83e3bb45f3d2dff74542960dc8d3a9a0e7a910c0129add8e35b4a462111394"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"prek", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prek --version")

    output = shell_output("#{bin}/prek sample-config")
    assert_match "See https://pre-commit.com for more information", output
  end
end