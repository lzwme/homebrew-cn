class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://pwasforfirefox.filips.si/"
  url "https://ghproxy.com/https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "e5d1ea4cd0d8f68c6d34502f7a94f767ae4157a3755b07162e4f0cc84f2d58a1"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8bfb45b1a0b74f384feb24a82daf8e0ec232255e423ca8ee6f87519d3a90a99b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db565d0cd145686ed6f8f450f0509e9594b53657159c6362bff36d7fb4eb4f38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5d943ac692f833b98aa9b46af69a81f37899fe06f2cca4ca2681ab71ba9c61b"
    sha256 cellar: :any_skip_relocation, sonoma:         "5f1d4bb8ad084457c0907114faebb9f6d8ecece4175b40f2dcb059cae917b4a6"
    sha256 cellar: :any_skip_relocation, ventura:        "a15adc66ce1d53780f14aea5a714c72f295a38d7dd0404307dc03cd52f916ea4"
    sha256 cellar: :any_skip_relocation, monterey:       "42c79f303d69eb6433362e05e8b5f28cf92af3a1e38310b0ec4df26f019d699d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5182533af911d098d7cff41c8d0b7411ab213860e9a2c8130fde8c9eb1d55dc"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "bzip2" # not used on macOS
    depends_on "openssl@3"
  end

  def install
    cd "native"

    # Prepare the project to work with Homebrew
    ENV["FFPWA_EXECUTABLES"] = opt_bin
    ENV["FFPWA_SYSDATA"] = opt_share
    system "bash", "./packages/brew/configure.sh", version.to_s, opt_bin, opt_libexec

    # Build and install the project
    system "cargo", "install", *std_cargo_args

    # Install all files
    libexec.install bin/"firefoxpwa-connector"
    share.install "manifests/brew.json" => "firefoxpwa.json"
    share.install "userchrome/"
    bash_completion.install "target/release/completions/firefoxpwa.bash" => "firefoxpwa"
    fish_completion.install "target/release/completions/firefoxpwa.fish"
    zsh_completion.install "target/release/completions/_firefoxpwa"
  end

  def caveats
    filename = "firefoxpwa.json"

    source = opt_share
    destination = "/Library/Application Support/Mozilla/NativeMessagingHosts"

    on_linux do
      destination = "/usr/lib/mozilla/native-messaging-hosts"
    end

    <<~EOS
      To use the browser extension, manually link the app manifest with:
        sudo mkdir -p "#{destination}"
        sudo ln -sf "#{source}/#{filename}" "#{destination}/#{filename}"
    EOS
  end

  test do
    assert_match "firefoxpwa #{version}", shell_output("#{bin}/firefoxpwa --version")

    # Test launching non-existing site which should fail
    output = shell_output("#{bin}/firefoxpwa site launch 00000000000000000000000000 2>&1", 1)
    assert_includes output, "Web app does not exist"
  end
end