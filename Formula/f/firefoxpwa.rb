class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https:pwasforfirefox.filips.si"
  url "https:github.comfilips123PWAsForFirefoxarchiverefstagsv2.12.4.tar.gz"
  sha256 "de532916f7467ff7fc27035454ec8ec4dd21cfbe860133678f024eff67a2a595"
  license "MPL-2.0"
  head "https:github.comfilips123PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b36c55539cc36ad9f3bf22b81f750e178b0068097cd3e827970a47cc8bb4b33e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a9b0055e082ccca0b849e1381703a3014c704c46b51c724bb6e58aefa263e80"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f97d2b57a2107cb92ec1d1d97763a7a0d906c78795872394b5c9cfca0a0c845"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c9d71ad76b22a20a918f0d7425d2a8f7bf49fa69d46acdd69b07db7ee7a40b6"
    sha256 cellar: :any_skip_relocation, ventura:       "de43c81f1927762b33488e97f03aa4d081e1b380678cd4ac894ff024c90fb0b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2230327473fe4945c71eee96e21436556acc6bcaf198665cb92b94b0005c78b"
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