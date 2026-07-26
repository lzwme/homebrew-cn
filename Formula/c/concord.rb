class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.4.6.tar.gz"
  sha256 "314fbfb0cfe643868355edf2e8b81da4ea651fff5bb3626477c64f1f9b42a64f"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "084f7da23c3cecc768bb360fd757fac3fb5cbf875bc3ce6b1c0352c5873be2c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbef17f71784a541653e3f5b1dcbf22de66595a892e77502ddfde9538ce27c41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "475b4325a267fef9c66cd6fbddf5a4aa8d10c0b01e5bfc7100c32a491b301430"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f54f9348af52010a2df35121d4f2c068f367b81a37da6013b6eb7ce7b939788"
    sha256 cellar: :any,                 arm64_linux:   "8d6025ab31a8bfc1bbbfb3dc480a1abb75dbdaeb0973dc37bd14a2b007e71cbd"
    sha256 cellar: :any,                 x86_64_linux:  "d3e9e6269d0d643d570d5d4d9de85055e5954b5b6f3e250a0fd249dd50704f03"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "opus"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath
    (testpath/"concord").mkpath

    (testpath/"concord/config.toml").write <<~TOML
      [display]
      show_avatars = false

      [voice]
      self_mute = true
    TOML

    (testpath/"concord/keymap.toml").write <<~TOML
      [keymap]
      leader = "space"
      StartComposer = "i"
    TOML

    assert_match "concord config OK", shell_output("#{bin}/concord --check-config")
  end
end