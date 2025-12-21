class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.2.23.tar.gz"
  sha256 "0abd16080710f8efb5f32aac32486ac831d4226f7874c93566dfeab944d60417"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a78e0f6d1bb42f537f64bce3f80c6b83f8654532efb03c4bd1656bea487a8cb3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a013208409ead3639aa34e6d7379fe9c378ae87661142cf22d293ed0c0c5c4ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb17656fd3216fe21917d7df7f43fe1db6651eadd3ec9fe6268b8df205a1e61a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e72328ad9a0c0a6863c18367dd90a468e05241d23fb1ca8bceb0575e5de9db4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9da2b6febd16e01c2e797c177dec8de41ae0ae39591b862c0b9d20f18bdc4429"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a478de3a5a7722350d4d50c0f1e0e00c6fc125cc48e1ab12157334b603117fae"
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