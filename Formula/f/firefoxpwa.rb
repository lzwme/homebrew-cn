class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https:pwasforfirefox.filips.si"
  url "https:github.comfilips123PWAsForFirefoxarchiverefstagsv2.14.0.tar.gz"
  sha256 "19b55d4ce77d148313b19fb67ac53fb00ba55f5219b6819e415c5e133bc061da"
  license "MPL-2.0"
  head "https:github.comfilips123PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eff06c51392a92389440bd706a701350dd446419bb5f0baef92b36a7bc8e2b3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a31f94657d28d9fa0ea46fd076ad86990782c52f8f3efbdb8799fe7da5b5e2a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db3404d0e13adea868d6187c71935ea215920fd5f8d4dc6eadb2afe22b9dd712"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e9cfeeebe97876516acd293b3a16cc22b8d6ddb30f05cd9439d3996395fe3fb"
    sha256 cellar: :any_skip_relocation, ventura:       "8c908f1cc9843b8a0f44b0209e9e7e42e83b7631e4c6791145bcc42471a7866a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c609f7932b8fa6dd6a3df4173670d8ece975f950e639b2300d3db3504ce00f0"
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