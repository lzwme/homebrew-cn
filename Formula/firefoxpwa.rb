class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://github.com/filips123/PWAsForFirefox"
  url "https://ghproxy.com/https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "90824ce5f40c99003253236a6c1115095fbdcbdf8509280b9c00d7f043633c28"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0928722d8aa5738be4da4050a99cc95e5157d87bbb846a885a1e2dc571f7b0cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0ff5567804b9c24fda4d3cbb1486a9d7d5b2c5ff0a4193bfdadedd4c9d48fa9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb721cd42265959b97f6e9eb67e6cf2d5d99c50feac09906e61fafd43ea510d9"
    sha256 cellar: :any_skip_relocation, ventura:        "c4b8590f84b4e3a1b3fc03dc23f1cf0bebac10467ce9386e9ad1bffe6e09cf3b"
    sha256 cellar: :any_skip_relocation, monterey:       "9a32e33fb7d4e18861826b5d4068a0a347545bd5be5251d51c886b71509990f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b20fc8bf9de0df074f7abbdde143953e1cf3751e6d4f4536f2eb3caabebf349"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "baaf44e82ec9bc839987ba755dedda090768575f069aa4bb8ef8494d21329e12"
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