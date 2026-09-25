class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://pwasforfirefox.filips.si/"
  url "https://ghfast.top/https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.20.0.tar.gz"
  sha256 "dc35ddba5c37351f0726dee0bbf85a2d1d7df3f95f43e958df8afb3d59a3c4e7"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0b1e3a14faede097ed467064fde4d8fc3df104c367380b2b1452744902dd1312"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f9a2eb48c0d4a25cd39c950fa950d9aad583c2e19e6b57972d47be372e5f78b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "94b8067949481ab732de2609c6b8834a639bb4f1967fcf7360ac844972915681"
    sha256 cellar: :any,                 arm64_linux:       "f54a6d1751446e2d79df7ae84f7a985f5226685a06fb2cbad8c07f397e898e6c"
    sha256 cellar: :any,                 x86_64_linux:      "df67e62ece4a339420de153ad9106304c5f62d696a54dd5ea7ad987a63934403"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "bzip2" # not used on macOS
    depends_on "openssl@4"
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