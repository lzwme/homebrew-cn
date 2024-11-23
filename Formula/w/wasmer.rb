class Wasmer < Formula
  desc "Universal WebAssembly Runtime"
  homepage "https:wasmer.io"
  url "https:github.comwasmeriowasmerarchiverefstagsv5.0.2.tar.gz"
  sha256 "7e6aecadf26266bb6015da333be8d3b7b472af74e5882cf3ee996bbd20d2c95a"
  license "MIT"
  head "https:github.comwasmeriowasmer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "336d161608c70d24914130f64f66df928621d4e3cbd056ab3adbab390b85c687"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c54a6ddafc894b1a6b2656e21659f47e2f713d8e7cd848f958a2369cef2e5de8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "13e00b552e8f1bb5db3cfa6a3f285307e87ba0166ef10c9e417f498d3e7b3659"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb7a0c2fa45476f06a4028409c3e9b26c03727e72fd79071f058caba7eba9181"
    sha256 cellar: :any_skip_relocation, ventura:       "737f984d8cb3ce1285eeb7f1c381d16c3b71bd1ce9ffa52bd818a80d9804efdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa0fbc1f94ac34f38e69171963bcc1f0b7fbf216568bde544fc2c212a5a54aa9"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "wabt" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "libxkbcommon"
  end

  def install
    system "cargo", "install", "--features", "cranelift", *std_cargo_args(path: "libcli")
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath"sum.wasm").write(wasm)
    assert_equal "3\n",
      shell_output("#{bin}wasmer run #{testpath"sum.wasm"} --invoke sum 1 2")
  end
end