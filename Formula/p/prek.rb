class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.2.25.tar.gz"
  sha256 "0b8e342fc2ffba1d69a3d2bf35f575b0c7bb8404ad2bdf981ca502175ec9d092"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ee5ee023dcc35ce5e2bbdd0bcbddd0f82bc519a1ebf1fd39e787635b9e437d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c294074f148d82879f601c273fd135ca6c70a62c9123fa953d1b7e7c8964c565"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9e450a2434a4e392304b877425bcfba17266496b12df14b64ed54c32056b790"
    sha256 cellar: :any_skip_relocation, sonoma:        "eabc0ce8cc13b53d4b8a04b1b23e4eef8b9dfd9bdce0b5012c6a6ebee3553025"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3471eb2205538f689200eb7246e065f69444bc323d908cd79050dfe1e874236e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "260a91961655303e8fe997a6edb4c8402b929f14adf5e41f401b8eb71ad848e1"
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