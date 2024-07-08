class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https:aptosfoundation.org"
  url "https:github.comaptos-labsaptos-corearchiverefstagsaptos-cli-v3.5.0.tar.gz"
  sha256 "38aebbddd053c2bba9bfccb74d39d125f51dfefcff2d03c831d6e86bfbaea68e"
  license "Apache-2.0"
  head "https:github.comaptos-labsaptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(^aptos-cli[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "533997273811c3394c46c19c86b028d33d55d1c652eb7fa2fe569cf75b0270e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29d41b5a67f29a3f6355f2d278cb5b166a527f3b79fe46fc7af8b0ba474e75ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b09c22fc6813cf40b080fdf4d1edef04bbf450b31670708b02a50536e6b5768d"
    sha256 cellar: :any_skip_relocation, sonoma:         "43966b0529bb33faa29de8c865da0306785ca465e005f70eec82812bd17e5c17"
    sha256 cellar: :any_skip_relocation, ventura:        "53d0b829996af8d3c4ac8698c4f9e11f882d3376c279729718e8ab6ac4de6d28"
    sha256 cellar: :any_skip_relocation, monterey:       "dcf273992208a14560dee5ee9f2b1f3155a75747fd76b73651d5b5fbc33569b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f35137a3c843247060c73c2ecb9234d44f5783c9ca7eebf18f2e5a0ddd5b5012"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "rustfmt" => :build
  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "zip" => :build
    depends_on "openssl@3"
    depends_on "systemd"
  end

  def install
    # FIXME: Figure out why cargo doesn't respect .cargoconfig.toml's rustflags
    ENV["RUSTFLAGS"] = "--cfg tokio_unstable -C force-frame-pointers=yes -C force-unwind-tables=yes"
    system "cargo", "install", *std_cargo_args(path: "cratesaptos"), "--profile=cli"
  end

  test do
    assert_match(output.pubi, shell_output("#{bin}aptos key generate --output-file output"))
  end
end