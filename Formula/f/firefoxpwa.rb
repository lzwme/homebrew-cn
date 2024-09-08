class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https:pwasforfirefox.filips.si"
  url "https:github.comfilips123PWAsForFirefoxarchiverefstagsv2.12.2.tar.gz"
  sha256 "0cd68b1c21b696eb19d8d7cbb99b13ba6fcc2e5158cbd3e08edc8e6c1066f5c5"
  license "MPL-2.0"
  head "https:github.comfilips123PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b8847067acbb4813d41e7dc8bd6546f11bee06a72cd4cf2b54e28bc9ad9315e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b474cdf7fe206d95ec00b5067a4a6ed491b925cbc5225b700673645a0921c95a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5144237517dd4c9f1138992198af01d945dc6b4fedcb904f79b5598f07e61e69"
    sha256 cellar: :any_skip_relocation, sonoma:         "f57072292be122fc92b462944498dd10fe0e91e5e7597644b53486c05475a8e1"
    sha256 cellar: :any_skip_relocation, ventura:        "3fbea87b7407abef147d8afe33d44454edbfb52283701f984d7a6177f6adf591"
    sha256 cellar: :any_skip_relocation, monterey:       "4c5eeca5ad206b97f3adac49c6ecf075ec12380e86f6bf67b9b70bd415ba58b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb1ccc6e2564f312ef62ef8fb1c3cd66ae4ef746bc07a8d718475610e1ce7427"
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