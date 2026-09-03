class Prek < Formula
  desc "Fast Git hook manager written in Rust, drop-in alternative to pre-commit"
  homepage "https://prek.j178.dev/"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "dc4d9256794fc1be3ffb54186cdafd467446e6628d72f2bed4a31d1e35473595"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8a0e2e4158f82e8eec2c97c2bb029684b99c3c7072566fa4b68151b0501e55b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef874cd67de4b6277b3a3e89eec38f09d4e780d25ff816b3d0bb191f1b70481e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c428d68c0d5907f382975771a71dd78a5040abb8a475fce17a37733142c2a93"
    sha256 cellar: :any,                 arm64_linux:   "eafbe1681c2b96b44f1bb60466cc2e1118bca6ba63ae11a93fd808c16b9dc15d"
    sha256 cellar: :any,                 x86_64_linux:  "48d81d309cdd81df581f255a2a24236adee83d81d02a483aab1a2571c7bf7763"
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