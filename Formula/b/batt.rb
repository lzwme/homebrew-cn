class Batt < Formula
  desc "Control and limit battery charging on Apple Silicon MacBooks"
  homepage "https://github.com/charlie0129/batt"
  url "https://github.com/charlie0129/batt.git",
      tag:      "v0.7.5",
      revision: "8148dfc57114f01db7af11bc4ce6ed99b72ea9d8"
  license "GPL-2.0-only"
  head "https://github.com/charlie0129/batt.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1a3326e9906d6cc8538095913010873f5419fbe646734dedc85288baa86158c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4c0fb34c0e709602ce5fdcbd65bacbd5636805ab517128a2266669eaf611f4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8312cfb4af9aa9ff5179a98d81b1d1d08d0a8efc6fc4c37281275b4887201e21"
  end

  depends_on "go" => :build
  depends_on arch: :arm64
  depends_on :macos

  def install
    # GOTAGS is set to disable built-in install/uninstall commands when building for Homebrew.
    system "make", "GOTAGS=brew", "VERSION=v#{version}"
    bin.install "bin/batt"

    generate_completions_from_executable(bin/"batt", shell_parameter_format: :cobra)
  end

  def caveats
    <<~EOS
      The batt service must be running as root before most of batt's commands will work.
    EOS
  end

  service do
    run [opt_bin/"batt", "daemon", "--log-level=debug", "--always-allow-non-root-access", "--config=#{etc}/batt.json"]
    keep_alive true
    require_root true
    process_type :interactive
    log_path var/"log/batt.log"
    error_log_path var/"log/batt.log"
  end

  test do
    # batt is only meaningful on Mac laptops. There is not much we can test
    # in a VM.
    assert_match "version=v#{version}", # Shows version
      shell_output("#{bin}/batt daemon --config=#{etc}/batt.json 2>&1", 1) # Non-root daemon exits with 1
    assert_match "batt daemon is not running",
      shell_output("#{bin}/batt status 2>&1", 1) # Cannot connect to daemon
  end
end