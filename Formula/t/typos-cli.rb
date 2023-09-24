class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghproxy.com/https://github.com/crate-ci/typos/archive/refs/tags/v1.16.13.tar.gz"
  sha256 "99b4ded7f70ece732f0543636e092403a5a3498e6bb16e63b5e2ab598fc14f10"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b3663e29770626243d6adc852464a38ef2d34995600369ce052fba8a368bd88"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83b152724268f689805e1fdb2b71820e4dc004746fc3d3b864f805affb3f5b3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77aaffb4fb5b7382f26b07ecdb5a79dcf840dce75b02c777a616bbce84026db1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01ce5766602a33faa5968c5756848d8df2f894f740bb2726cb81de189a2b7e0e"
    sha256 cellar: :any_skip_relocation, sonoma:         "23cd113b416f12bffa26ac4ba5478890da7aba4b2b619cebd9c07f43b2587977"
    sha256 cellar: :any_skip_relocation, ventura:        "ae62544d707dc28494e892dc567b243735d2a09a89c6433b5eab3e5c4368658a"
    sha256 cellar: :any_skip_relocation, monterey:       "e483ee8823103404b93d8c8bbde68881a05dcfa4ec6dfede99f0d32a2f88e3c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "62812b83627b95f0c5129b55732725df968c599423d769f2a8ad043a2ec6ac26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fea75d56e5afa177020aa46ce625a2961c907898d41c55ad58e97eb687919139"
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