class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://github.com/filips123/PWAsForFirefox"
  url "https://ghproxy.com/https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.7.2.tar.gz"
  sha256 "f19bef914a48d936fc4aab01757108e3bd6bc93e10e54f60844df630fbfe7ef1"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3d85c3d96f053d009181de1962c5d5ee7b9d70ac26ab31f804d2e48dbfd8557"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aedc2159c4928471d33475521919ccc0082f2af898bc8770943e9b6fd32e4916"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43c7466a9ee1b2f92b84804324e100e199423986044c8013acdacb650cf6ed06"
    sha256 cellar: :any_skip_relocation, ventura:        "0b0b381c4da0d4a4a583553a178cca3282846b1585477dca2b2e33a1d72f9f6c"
    sha256 cellar: :any_skip_relocation, monterey:       "67b4f3c6fd44a7960fcd943ffcf27b0c0a8bcbd73e891ff2e06e54396c607e17"
    sha256 cellar: :any_skip_relocation, big_sur:        "cfa684424be730f889e577a32fd5e075c446f094a0b284421bde08f8e252ac34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc39362bbe1cdd5e565bcabc35e1d152194e90648d40a2037bba8a5e4285ae2f"
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
    system "bash", "./packages/brew/configure.sh", version, opt_bin, opt_libexec

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
    # Test version so we know if Homebrew configure script correctly sets it
    assert_match "firefoxpwa #{version}", shell_output("#{bin}/firefoxpwa --version")

    # Test launching non-existing site which should fail
    output = shell_output("#{bin}/firefoxpwa site launch 00000000000000000000000000 2>&1", 1)
    assert_includes output, "Web app does not exist"
  end
end