class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://pwasforfirefox.filips.si/"
  url "https://ghfast.top/https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "772ef9461aaed98f90f772f8e01070272048f7607ac061b56f1af4ab5f8bbade"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44105b4fb962afff1e221239e0b6b3859e33aef3b9975f0a02bfaeb502614def"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60879b5d614a0f7584811a71b2926e94b41bb7a1e79befa5ddbd60c83aca9f41"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5ffecc9264d4c3e52b49f063e4d97c8ba4c9c1f94da6cc2140ed0ee29e264418"
    sha256 cellar: :any_skip_relocation, sonoma:        "49bc7ac80b7c712a3879ec0bd51b11366c3432d3e860b4debde5fcc1bbf761a7"
    sha256 cellar: :any_skip_relocation, ventura:       "916a89368de04e1b5eba2c00e1bc5fa8caa7a013912974096cc6e170996d246f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "094c1f2c2c9ec197dfb12fd601d9dadfb5f72efe821f25bdfb933b8700da9443"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4987e1dbb7ffa3a9c1b46724a8b082a24a0e2a7c18579e162d687bf30201f98e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
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