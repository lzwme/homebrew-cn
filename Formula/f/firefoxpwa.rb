class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https:pwasforfirefox.filips.si"
  url "https:github.comfilips123PWAsForFirefoxarchiverefstagsv2.12.3.tar.gz"
  sha256 "7917c9c1a888c37a12f2263c11389121b7ca9eb7c6c4e7c71426e0a4326cc4d1"
  license "MPL-2.0"
  head "https:github.comfilips123PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "87837b77966e94b879f25d40213e2f4ce376b4be7115397cf1301f9b9aa58f23"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "757e919e94c4d84e991eaf865d4f23f9fa4373805e0abed9245ea1dfafe704b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c36b904d520abeedcc138678799ce4e7cc633a49bd1ec10bf1b8de6814ca5c04"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ca73fbfee8b0c384033fa9ed4a64d064db5a642681a3922e4178c121ef28767"
    sha256 cellar: :any_skip_relocation, ventura:        "b0e730bb3596efcd74b5cdd8a617306eb30ed8b8ec83201d04d13b1e03f5578d"
    sha256 cellar: :any_skip_relocation, monterey:       "acf0c0c5e3c386b9e83687a9eeed0e7631cae4cbb101a8e546e7f9e61a0d5251"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b88726bb55d1df9c2ef2f5c6a1f04d95b669ace4849e2d881922481edb4b4474"
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
    system "bash", ".packagesbrewconfigure.sh", version.to_s, opt_bin, opt_libexec

    # Build and install the project
    system "cargo", "install", *std_cargo_args

    # Install all files
    libexec.install bin"firefoxpwa-connector"
    share.install "manifestsbrew.json" => "firefoxpwa.json"
    share.install "userchrome"
    bash_completion.install "targetreleasecompletionsfirefoxpwa.bash" => "firefoxpwa"
    fish_completion.install "targetreleasecompletionsfirefoxpwa.fish"
    zsh_completion.install "targetreleasecompletions_firefoxpwa"
  end

  def caveats
    filename = "firefoxpwa.json"

    source = opt_share
    destination = "LibraryApplication SupportMozillaNativeMessagingHosts"

    on_linux do
      destination = "usrlibmozillanative-messaging-hosts"
    end

    <<~EOS
      To use the browser extension, manually link the app manifest with:
        sudo mkdir -p "#{destination}"
        sudo ln -sf "#{source}#{filename}" "#{destination}#{filename}"
    EOS
  end

  test do
    assert_match "firefoxpwa #{version}", shell_output("#{bin}firefoxpwa --version")

    # Test launching non-existing site which should fail
    output = shell_output("#{bin}firefoxpwa site launch 00000000000000000000000000 2>&1", 1)
    assert_includes output, "Web app does not exist"
  end
end