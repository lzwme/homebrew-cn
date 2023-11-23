class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://ghproxy.com/https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "c5ff234f799b7ca8bc9ae5719333366cc15a7a70284a19503ae925a0a48f3f04"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f0d9e65b3aaac29b5267fa70ffdddf1be62fd582dc7874ff6b8c510a7c2146c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1ea8b3a6998fee10dbab648b049010ed1dda59b3a7db73ee851d608b405fa9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a78c1658acb6850bb8b016864e393b60a826bb1409bcc7024fbb00e2864998d7"
    sha256 cellar: :any_skip_relocation, sonoma:         "65199b5da081e5e39dbc590e1504f19367022a911eaf28f01996f8f5a6301dae"
    sha256 cellar: :any_skip_relocation, ventura:        "2131710ef745bdd756f3d86cf07a6accdb825cf250238a925f605fa5e9d6aa25"
    sha256 cellar: :any_skip_relocation, monterey:       "6b578e50f3d9bc1b5c95cdaeb82d17b21e59864e2ef6b57fd6dd4b2fc5e3ea55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb0fd611ae35872f255f0523d3d1f482d7a6e7f2cd2ecdeb4c3e11845e23313c"
  end

  depends_on "rust" => :build
  depends_on "rustup-init" => :test
  depends_on "zig"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Ignore rust installation path check
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    # Remove errant CPATH environment variable for `cargo zigbuild` test
    # https://github.com/ziglang/zig/issues/10377
    ENV.delete "CPATH"

    system "#{Formula["rustup-init"].bin}/rustup-init", "-y", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    system "rustup", "target", "add", "aarch64-unknown-linux-gnu"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      system "cargo", "zigbuild", "--target", "aarch64-unknown-linux-gnu.2.17"
    end
  end
end