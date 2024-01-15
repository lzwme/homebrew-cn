class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https:github.comrust-crosscargo-zigbuild"
  url "https:github.comrust-crosscargo-zigbuildarchiverefstagsv0.18.2.tar.gz"
  sha256 "a43eab1ec15496e4fddf01fcf348e86402d6a85cf4a378f9f316344d8159df3c"
  license "MIT"
  head "https:github.comrust-crosscargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6f08f29f2617bdb5f5db13b50d5f73891f59bc2702d7012628db8a367da3018"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6366cd6660577f6961c22d579683bb9eddb7478fa34eb048744eb63e56781e7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "288bd46e5aa8c9b71ff6a423f43a7e8003c39aaae163dacb8a0e691ef1abd2eb"
    sha256 cellar: :any_skip_relocation, sonoma:         "be155893ded27b8406ac4450187c15ab560c8feff0a63975866a5a7f7b9b9dcf"
    sha256 cellar: :any_skip_relocation, ventura:        "749af1d56c843966e5c536fd2e5a1d2c5660d554f7597d7e94efe2ef9951fd20"
    sha256 cellar: :any_skip_relocation, monterey:       "65a1d11c5acc85890ecc0c729d5cf0631b8da5dcb9327ce153d155da9b349d92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9142b6a210ef72d7fb5ed5fe1d575df5848485c1f5d097c13dd3045bb579ce06"
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
    # https:github.comziglangzigissues10377
    ENV.delete "CPATH"

    system "#{Formula["rustup-init"].bin}rustup-init", "-y", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE"cargo_cachebin"
    system "rustup", "target", "add", "aarch64-unknown-linux-gnu"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      system "cargo", "zigbuild", "--target", "aarch64-unknown-linux-gnu.2.17"
    end
  end
end