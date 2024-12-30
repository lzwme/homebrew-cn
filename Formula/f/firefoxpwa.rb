class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https:pwasforfirefox.filips.si"
  url "https:github.comfilips123PWAsForFirefoxarchiverefstagsv2.13.2.tar.gz"
  sha256 "0afc169fa5d02624ed417fdaf26cd719300bae6709d8d7ca74987425b8e62b66"
  license "MPL-2.0"
  head "https:github.comfilips123PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd891b5a51d292a0eac3b2dc885bf6fa5f75a7c802bf1a5b1c2091f751054d47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6181f7307dc029479be23904ee56da60af7b35a1e3ded3cb9a5f8cdf7ac7013"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "16c258c115a23e5f41b037ce3c0023c27e383cfbe6c499181c702445699b3445"
    sha256 cellar: :any_skip_relocation, sonoma:        "6723e6246ad1631adade8a0fdf1d3e05f9d1188b4b54fd91e158b13d38168d3f"
    sha256 cellar: :any_skip_relocation, ventura:       "8da37050db7eca5c98ba3e51a408357534ab76f0594b623309603f6da10ac2c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e372b1750cbc659b5caaaf3a1027ad4a4f003a7532229d693c3585ecc6cba9bb"
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