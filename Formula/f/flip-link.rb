class FlipLink < Formula
  desc "Adds zero-cost stack overflow protection to your embedded programs"
  homepage "https://github.com/knurling-rs/flip-link"
  url "https://ghfast.top/https://github.com/knurling-rs/flip-link/archive/refs/tags/v0.1.11.tar.gz"
  sha256 "d32d9c79ae93a46e721b809a103ffe8fc7d1e0a71f661a4221845dd63048e675"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1d14b41d7a365ac7e142963da71c68ad9beb1edf982ff496958c995e509d984"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "621b648f75e43a4420e18172f793f7a463fd17baabec6e97ea99eebda1f4d0c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c2648567684cbe7355c7f236c3f450d0c42c9f666dd43e6fb5d915acf32ce5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "247129566c8f6e753da4eb7f62e2647b0c39a5a62ebb6e4c3a60e1d2d951462b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "302b0798e23f79898a0cf97844bfc3da1c4dbcbdb8e82e502d7ba1d9b73836ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "703058fc74a4a733f2d07da1c60fb4bed988ca55bf8a92d2803a3c5470d642fb"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
    (pkgshare/"examples").install "test-flip-link-app"
  end

  test do
    # Don't apply RUSTFLAGS when building firmware
    ENV.delete "RUSTFLAGS"

    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "stable"
    system "rustup", "target", "add", "thumbv7em-none-eabi"

    cp_r pkgshare/"examples"/"test-flip-link-app", testpath

    cd "test-flip-link-app" do
      system "cargo", "build"
    end
  end
end