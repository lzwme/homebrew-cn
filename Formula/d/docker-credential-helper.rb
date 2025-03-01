class DockerCredentialHelper < Formula
  desc "Platform keystore credential helper for Docker"
  homepage "https:github.comdockerdocker-credential-helpers"
  url "https:github.comdockerdocker-credential-helpersarchiverefstagsv0.9.1.tar.gz"
  sha256 "aa4c2aa7987e780769b116f5cef263c13813ef9d40367c7830f71ce486c937b3"
  license "MIT"
  head "https:github.comdockerdocker-credential-helpers.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c4d3952b99dff8c1a00a934c006f588c1a6ddf9191b809e0dee399b5c3d24b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f6b8166ec7c92dcf3126f64cffcb715bd84f76985dbb9358e48caec4b403fee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2bd2e25684f04c1c4b7fed88f1b865710613aaea91e03f24ecbd4f9c5408f59e"
    sha256 cellar: :any_skip_relocation, sonoma:        "678d6dd2deb4b1c06e8b87e0a9fc8522f04523c9d81eb0afb30a06e406a814f5"
    sha256 cellar: :any_skip_relocation, ventura:       "b9190eff7c746575e7d2deab3bd4a57024f31b10168ff0e599e9213e94925933"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73960b75d9aa46d4b61c4188097c72406dddc0821e5e0293c22230e0444cb6fe"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "glib"
    depends_on "libsecret"
  end

  def install
    if OS.mac?
      system "make", "osxkeychain"
      bin.install "binbuilddocker-credential-osxkeychain"
    else
      system "make", "pass"
      system "make", "secretservice"
      bin.install "binbuilddocker-credential-pass"
      bin.install "binbuilddocker-credential-secretservice"
    end
  end

  test do
    if OS.mac?
      run_output = shell_output("#{bin}docker-credential-osxkeychain", 1)
      assert_match "Usage: docker-credential-osxkeychain", run_output
    else
      run_output = shell_output("#{bin}docker-credential-pass list")
      assert_match "{}", run_output

      run_output = shell_output("#{bin}docker-credential-secretservice list", 1)
      assert_match "Cannot autolaunch D-Bus without X11", run_output
    end
  end
end