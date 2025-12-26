class Batt < Formula
  desc "Control and limit battery charging on Apple Silicon MacBooks"
  homepage "https://github.com/charlie0129/batt"
  url "https://github.com/charlie0129/batt.git",
      tag:      "v0.6.0",
      revision: "1310e0b06fe91ac206ef298fd129bde611f3cd5f"
  license "GPL-2.0-only"
  head "https://github.com/charlie0129/batt.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f204e8c765569dc0b604524664570bf9ccf666d01c1ab2f91e52f750b6c987d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0e4310120c5236ffbc39e3e7652e596b45f29a33b986e3cd993e42e4a415b35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea694cb39f7046a7e318a133c580ff5cc8e339dfc2220c521b43d0392f1009cf"
  end

  depends_on "go" => :build
  depends_on arch: :arm64
  depends_on :macos

  def install
    # Point to the correct path for the binary
    inreplace "hack/cc.chlc.batt.plist", "/path/to/batt", opt_bin/"batt"
    # Limit config path to Homebrew prefix.
    system "plutil", "-insert", "ProgramArguments",
           "-string", "--config=#{etc}/batt.json", "-append",
           "--", "hack/cc.chlc.batt.plist"
    # Allow non-root access to the battery controller.
    system "plutil", "-insert", "ProgramArguments",
           "-string", "--always-allow-non-root-access", "-append",
           "--", "hack/cc.chlc.batt.plist"
    # Due to local changes version tag would show vx.x.x-dirty, override VERSION.
    # GOTAGS is set to disable built-in install/uninstall commands when building for Homebrew.
    system "make", "GOTAGS=brew", "VERSION=v#{version}"
    bin.install "bin/batt"
    prefix.install "hack/cc.chlc.batt.plist"

    generate_completions_from_executable(bin/"batt", shell_parameter_format: :cobra)
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
    # batt is only meaningful on Mac laptops. There is not much we can test
    # in a VM.
    assert_match "operation not permitted", # Non-root daemon cannot listen in /var/run
      shell_output("#{bin}/batt daemon --config=#{etc}/batt.json 2>&1", 1) # Non-root daemon exits with 1
    assert_match "batt daemon is not running",
      shell_output("#{bin}/batt status 2>&1", 1) # Cannot connect to daemon
  end
end