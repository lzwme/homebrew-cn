class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.2.24.tar.gz"
  sha256 "8f9d55b275305a19f4a9e8c7fc90331491c443ed45fd4d7f59d05523b571bdb5"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c68d9746afbec4280f2a58b344ad95dabda1073fdad2d4a42dffbf9c8c489f08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95b1f9abfd42eb8c4ea383ada541c3dcf13274673ec38c471cb574c21cbd4adc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef2ef02798945e2cc9843bf4fa017afada8a38272fbb64de300c1127a06b8b45"
    sha256 cellar: :any_skip_relocation, sonoma:        "06a23badfa9b1ab58509ff5cbf396ed94174844b83b2b708620caea50356073d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59df52e95703358410b2c0046d48b65e8a1d1524b78d8e0a1e0b92c0af564f60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe1c89e6c3244c9d31b2c2d7c078d353d2e9596a3546e24a3cd1dedd9da9e0c1"
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