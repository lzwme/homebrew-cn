class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghproxy.com/https://github.com/crate-ci/typos/archive/refs/tags/v1.16.4.tar.gz"
  sha256 "4306b94393b21837abdc84f87f6365ce20edecfa85ea6b60c1b3a2ab5bfd409d"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e284d705c385c1b27ae13adcabaa0b7afb5644fe438cd159aff238078f516e07"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f42a7c158fd7f23cab35d835f7b8f37f6e0d707bcbae230fa8d548e3a69f1a4f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef034b5ef1c2f64df27af540f4270879d5156aa348ba479c6a543b4c691803ce"
    sha256 cellar: :any_skip_relocation, ventura:        "f07e8a2a44158536c31ec22aa47087f54a392d8c16f8dfe714ecaf16dffe4ba5"
    sha256 cellar: :any_skip_relocation, monterey:       "e003be8007eba227b32e3cd9cbe915b626d7300ddc63846925765c2c8a9db7be"
    sha256 cellar: :any_skip_relocation, big_sur:        "d75175d78a85f4046c8e0735af1e287b58fdb65737d537b6c9095a39876f1143"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a08407b658798e243e42e1ab519cb1da56342bb036cee577bfcc20924d7e448"
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