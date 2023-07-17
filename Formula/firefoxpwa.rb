class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://github.com/filips123/PWAsForFirefox"
  url "https://ghproxy.com/https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "409344b901408a785386fc500d36b3a265141c111ff6fd0870241d14788b5f31"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4f5b1c8a714d67938367f56a75b9c2b997f8ad6481bfd97d8716250fcf72380"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29d88bacafe423b2aae96bcefa10b603cc058fce7f1cdf144bcb11020dfe353c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b7f3d1f6530254f3d5d8d763ba48c1a4fb52a78fcb71c768135fe0fa5eb74b0"
    sha256 cellar: :any_skip_relocation, ventura:        "0826660e1d2329cda0e5b960cbf0b3836baa466061bb5a9138ea9d5cffad830e"
    sha256 cellar: :any_skip_relocation, monterey:       "292f42686c9a10c33d892db059c8ac02e81580356bf1dce109dcc02f42568873"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4486c07e1cd3a50612cf975640c0259ef42e682a1f268591d8c2562d3a463c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24fb9b38824098f051f1ca273334ff24c8a98f79b63ec5958184b06f9aa30eae"
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