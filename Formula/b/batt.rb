class Batt < Formula
  desc "Control and limit battery charging on Apple Silicon MacBooks"
  homepage "https:github.comcharlie0129batt"
  url "https:github.comcharlie0129batt.git",
      tag:      "v0.3.5",
      revision: "cd02fbd32599c0347073f1535cf88fed99e8f8a7"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32ae325674cd77dab14edb61c5bf1770ee4222d0f4fba05afde72afd0817dca8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbb54b9c9b8ab30b7369b2b81ec49a3de3b78561102b79d96b33ccfd575c00c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fdcf8bb446c07a3ef8dc9e261833316a80c7813c49409c5edd96e8808ffcd82a"
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