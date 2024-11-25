class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https:pwasforfirefox.filips.si"
  url "https:github.comfilips123PWAsForFirefoxarchiverefstagsv2.13.1.tar.gz"
  sha256 "d0af7a8b97555ed46cc6eb8f971e520149c9a4b520f0c0364b67530d0cccd8a1"
  license "MPL-2.0"
  head "https:github.comfilips123PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2d4e37ab715d2ec6bc440835f51c1437e46096b5f6c1e98ef88924920acb610"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4868985f8c2fb489703c354d906d09859e17ce40728ab4ce2b9ee11e0ea4f338"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "38b2d08a516d85c301d4a8d53c4282b29abd180d04cc63d9858db90f38ebd404"
    sha256 cellar: :any_skip_relocation, sonoma:        "858c39c4fbd38e6adcd81ace8764dad99a969152ec3ba7b145efb312464d8d45"
    sha256 cellar: :any_skip_relocation, ventura:       "06236fe788099dac0a60b93a23999243e29e63e6dc27104876dbf0b85627e5be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "093e5a9dc084870bb9485a021d286d8d391277596aefc69d4a6f0a05c74f9bdb"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
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