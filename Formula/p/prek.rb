class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.2.20.tar.gz"
  sha256 "354126214981186b9ceae8c72c08f94ad2a42f2983ca9b433f860fab9cce3481"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40cf7760f4b96dd666f31a31e0d5dc563fe488d55606c12a65ed6e77d9b309a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab93131bf4c8a44bb39dd9a52e12d602ea2cc2c425d18e13fb27e4c21a475594"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e00c26e4c2cd5bef37f60567e839ed22def6ab8e5c53fa6022a4776e6f6745c"
    sha256 cellar: :any_skip_relocation, sonoma:        "bba43acaa711fe93e2014d5593154e93e9c6584e537251ba0d1c491c490f806b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39958fe404fce8c6d9ec207e5f24fc39f292b77840094b2188cdb2df13a3b9b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2977c930de7c53f59e0459603a64e9a9fbaee766dc66171ebaf41807045a245c"
  end

  depends_on "rust" => :build

  def install
    ENV["PREK_COMMIT_HASH"] = ENV["PREK_COMMIT_SHORT_HASH"] = tap.user
    ENV["PREK_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"prek", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prek --version")

    output = shell_output("#{bin}/prek sample-config")
    assert_match "See https://pre-commit.com for more information", output
  end
end