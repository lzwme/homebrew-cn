class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https:pwasforfirefox.filips.si"
  url "https:github.comfilips123PWAsForFirefoxarchiverefstagsv2.11.0.tar.gz"
  sha256 "16a0d92fab9167059dbbdd14213e2a92285deb3c2c4917a29f7a7d1709aee973"
  license "MPL-2.0"
  head "https:github.comfilips123PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d8c4048eb3334ddff4cd16f22b595b1d6555d5f855d819b588e40027ec1b7a2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "255809306cbe9f777e0d11697070c165cdfc27f6c1186a33daf65a2885e2cceb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cac986e17a05de08282ef943acd0fb753a9abce01a52f4d2f8144982f3581bb5"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ce55317f7f6920f82b2185ccbe81bde2189bd50d3ed06e167ebc8d741b241ab"
    sha256 cellar: :any_skip_relocation, ventura:        "9f96686bcb33527490a21c5d034dec38a390967ee3818ec81e46e93e70b6f292"
    sha256 cellar: :any_skip_relocation, monterey:       "28a61c83f24640b41278f72d574f4929b4afa6051cb846040b45be26ed74fc85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "287ed8ffd8e7177939e0c0816573fe6068144c0791a6f4fa07195f518259d30f"
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