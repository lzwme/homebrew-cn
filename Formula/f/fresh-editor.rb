class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.4.9.tar.gz"
  sha256 "07e2650604e38d9bbb9e8df51e339a92b0a8c049e5c15d5eb2e7d4c8650dd745"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a62eb3c14252e2b8fbbfea013bc6d1f6a532ad8c300b6859318901404703a61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7fb0264d0a0373154217929110c59cfbe07d7a71a19a14e3814dd7d684223be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69f56ec4f204f57b2f11209d4efc791bcfbb990d2fb180b53b4fdaf3e73de970"
    sha256 cellar: :any_skip_relocation, sonoma:        "205edc2b5d293864371da8237b8dd4a15a6866da8d9ac91ba667ce612ede23e0"
    sha256 cellar: :any,                 arm64_linux:   "f7fced943cd51c3fb9349a7455769eab13890585c6ac9e05c41539152b2a9be2"
    sha256 cellar: :any,                 x86_64_linux:  "d0e199c4ab4d21f97789d45c8d066ec280169a1a41ca161f2c1fd98a9b3d6370"
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