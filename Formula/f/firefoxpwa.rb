class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://pwasforfirefox.filips.si/"
  url "https://ghfast.top/https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.17.1.tar.gz"
  sha256 "66d16fe3ba99790ff8a1e4e5f7c2a4f2b84055750b5caccff6cb9d6bec1d72f4"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a22d3b5644626743cf7c41b444e4f8c0964efdd3ad50aa2f09fc57800ee2da9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05f6c7eeec0db36734c83ac77f62db204ae1821ae5d44ca4f5c7ea13e48ec862"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ca377b67ea5219e69e6e105f41ba1d479915c30daa00aefbdeaf0cbee0a3bd6"
    sha256 cellar: :any_skip_relocation, sonoma:        "cdbb1d642e1b992382112f5e3559614e1f451fcda2b832bc2eed377384e3dcd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5384bb06d6ef61a8cfff18ddfab6c19a22a684cbf8eae0d6872189eea445ef4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdc2ffc693a08aaa32624a8975d87624203f05da61d1318645fb0ef2cd41feed"
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