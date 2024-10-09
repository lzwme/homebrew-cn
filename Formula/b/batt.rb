class Batt < Formula
  desc "Control and limit battery charging on Apple Silicon MacBooks"
  homepage "https:github.comcharlie0129batt"
  url "https:github.comcharlie0129batt.git",
    tag:      "v0.3.1",
    revision: "a7fedaf3ea1cceacf8b35c6d64277ee5a9d1963c"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61bd7790a82f2269b9a0ce1585c57564d03be4e4ac89b8f0d8843c0073a688e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "198bd7bb9a808f0a9e4cb1a31b7e9c2a72d690ba1d07ebddf78b6d0ce0b6dd03"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6eff598159b263327b8b562ab32f5e5e7157c20f25cbecfa08b48eda794c4c43"
  end

  depends_on "go" => :build
  depends_on arch: :arm64
  depends_on :macos

  def install
    # Point to the correct path for the binary
    inreplace "hackcc.chlc.batt.plist", "pathtobatt", opt_bin"batt"
    # Limit config path to Homebrew prefix.
    system "plutil", "-insert", "ProgramArguments",
           "-string", "--config=#{etc}batt.json", "-append",
           "--", "hackcc.chlc.batt.plist"
    # Allow non-root access to the battery controller.
    system "plutil", "-insert", "ProgramArguments",
           "-string", "--always-allow-non-root-access", "-append",
           "--", "hackcc.chlc.batt.plist"
    # Due to local changes version tag would show vx.x.x-dirty, override VERSION.
    # GOTAGS is set to disable built-in installuninstall commands when building for Homebrew.
    system "make", "GOTAGS=brew", "VERSION=v#{version}"
    bin.install "binbatt"
    prefix.install "hackcc.chlc.batt.plist"
  end

  def caveats
    <<~EOS
      The batt service must be running before most of batt's commands will work.
    EOS
  end

  service do
    name macos: "cc.chlc.batt"
    require_root true
  end

  test do
    # NB: assumes first run of batt, with no previous config.
    assert_match "config file #{etc}batt.json does not exist, using default config",
      shell_output("#{bin}batt daemon --config=#{etc}batt.json 2>&1", 1) # Non-root daemon exits with 1
    assert_match "failed to connect to unix socket.",
      shell_output("#{bin}batt status 2>&1", 1) # Cannot connect to daemon
  end
end