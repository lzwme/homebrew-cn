class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.2.11.tar.gz"
  sha256 "598bae6cd9f167dfd553b99b589f624bfe0c5c4b9280b543f602741d7e1aa016"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa52918cf4b6b1e23717a01e0fc89d0d7e735c4a3b39bd5ad7956ec39ea35489"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a65036a7634a851992d29a8442030d996e2dc1bd4e5cdeed8e2e106cc7004cac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c88b0c231e71236e95e69659d54e2eaf68ad4b3104eb774b2afe3a1f05792704"
    sha256 cellar: :any_skip_relocation, sonoma:        "d608b83bb8c601aa608ca1fe7a7c1afd5f2868a5f562646ee48481fb89d8c68b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e18f269ca8ca1af7a7083194115b7423a08318a5b33111ea2e106b87259e4be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cba9f23d2dcc81e42b327b3af7b009afc72aae55ea342db0484d7f81c26a4c09"
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