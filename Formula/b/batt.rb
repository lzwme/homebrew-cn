class Batt < Formula
  desc "Control and limit battery charging on Apple Silicon MacBooks"
  homepage "https:github.comcharlie0129batt"
  url "https:github.comcharlie0129batt.git",
      tag:      "v0.3.6",
      revision: "a6952e4423e9f9cd175db5175e9b62de96edc6b7"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e386881441aa6f47e924c68949b6ae352942a3afa4db2f224396a26f14a2f6d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0810f6d7f6f8dccad981dde2c0bed237665e8ee03a752c12d521bfa66441fead"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "77c72ae72c4bd6f8d26c510604d8313e5d4b573e65df7882a1305d8616b9f095"
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