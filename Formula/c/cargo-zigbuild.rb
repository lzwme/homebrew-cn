class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https:github.comrust-crosscargo-zigbuild"
  url "https:github.comrust-crosscargo-zigbuildarchiverefstagsv0.19.4.tar.gz"
  sha256 "c687decd7b443ad83538b4b809b5ed75d7f02cb8a56197ece5a8e0601706553d"
  license "MIT"
  head "https:github.comrust-crosscargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6075b3c1df596c0baa60ba05c79acbcafbcaa5e9102010cfb0be827cdc29666b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3e4c006bcb3476be836270e66044a7089d54b8cef2fce2c5a540a74bedd1f4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f57f837c374f857c1e6ceca05ccf191946d746974fd06f37d532346b67c8bf58"
    sha256 cellar: :any_skip_relocation, sonoma:        "410f7fecf82ef1fb0fadc2e9efa208a254d3d7c8aaca07157709e99e8529cc78"
    sha256 cellar: :any_skip_relocation, ventura:       "51f48d313e922a8fba0489498fe80ae044e01fc1138be4e888934fea2575d76b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f90e1b4e9dec925c03f694f98e6024ae23abf3924a0a764a026160dbd85d8bcd"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "zig"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Remove errant CPATH environment variable for `cargo zigbuild` test
    # https:github.comziglangzigissues10377
    ENV.delete "CPATH"
    ENV.delete "RUSTFLAGS"

    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"
    system "rustup", "target", "add", "aarch64-unknown-linux-gnu"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      system "cargo", "zigbuild", "--target", "aarch64-unknown-linux-gnu"
    end
  end
end