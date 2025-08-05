class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghfast.top/https://github.com/crate-ci/typos/archive/refs/tags/v1.35.1.tar.gz"
  sha256 "41e981cc763393b1374d2891f64c0ec62eb9b99320f4af6e1e3f4aa85fe1db36"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f0f6e1525fb3e086ab61eeb7d5f2c711dc62f3bdd0246e2c0c66103773c8265"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31d210a84bf3df8dbfcd3263e061eff14a04b5f6f02cf7d5695b03d0edd2e00c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "573509f78e9b434b3ce6f48223178ff71ac8882af26786bc9dc12a45a3702c1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "44f334168d05bef0bd89d0dc923d422cf4d885e8805460abc41b6cd1e73128ec"
    sha256 cellar: :any_skip_relocation, ventura:       "93c6aa86490d92cea25ba41b5434590c0f0e9a47cc986f305a64c0c2fb6e7d48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f4989b769fdca182900263b87ece99c08a2a25bdec85072834fbdad33b3e80e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f626c00155c971858e0dcecc9edcee4d17e81379ea79c0e329b7a7c346a277c0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end