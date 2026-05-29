class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.3.10.tar.gz"
  sha256 "1e4592e19cf7a95df5901e21d350f88534caf7fec9348801b76eabbf8d8d9c1d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05e7e355de9e8b02884aa57e3d3308f9c66638affb8768e53f41775c36ee114b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ba94f7dc49cfd0a42f93e91665831a3f35fd19005d7eaf0976682e773e18334"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02008b2c1807e4eadd73442699de8383f92deb8b20e324de9937a6225c31ef74"
    sha256 cellar: :any_skip_relocation, sonoma:        "c745943e748ff422b17ab6aa8765336b141a717c8260fd8bea2547a4323b2539"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa2e27fa802a72ff7b88f5ccf1703170c2dd8831e483f7d31f70c2ea31775588"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d094c4cf40bb28b735e2112bbffcb237d19f31b6c7ea4fb675925aaf8dc785a5"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang to build rquickjs-sys

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fresh-editor")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fresh --version")
    assert_equal "high-contrast", JSON.parse(shell_output("#{bin}/fresh --dump-config"))["theme"]
  end
end