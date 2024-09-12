class Cotp < Formula
  desc "TOTPHOTP authenticator app with import functionality"
  homepage "https:github.comreplydevcotp"
  url "https:github.comreplydevcotparchiverefstagsv1.9.0.tar.gz"
  sha256 "388e8fa94ee263423ae9dcb7d766fa3956d69c22e1a901f04aa0d7955834ea28"
  license "GPL-3.0-only"
  head "https:github.comreplydevcotp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "bc1a651cb444dc6abba45ae42d8fa1aeec739a98dc5f49160a73f484d5e1993b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "050a2238dafc960c2ae2fc6feb44655dbadfd0559ee72e2609e1dab8e03cc1ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5227d6c1ef90e09aa91b4eb53bd42d036cf9721e2293e6a151ef1f9e1df3fb7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b835091dd90d7e63860cb2ed9dea252768844edbd54e27e08574795e7f9bff3c"
    sha256 cellar: :any_skip_relocation, sonoma:         "5bb2de08fdcc5ccb2a13d0bce199cf5452a4eb4bfb830150be437fcf9411c065"
    sha256 cellar: :any_skip_relocation, ventura:        "de2c08704e8a7f0c7c14891c06ad1caa84757a084dbefa158f040020323a8edd"
    sha256 cellar: :any_skip_relocation, monterey:       "82de53c6019627f63ae8542c3573b5511e4d4c9d6019af4d6545596b9bf5c466"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3261ea3cc924895f4550d7ab5763436b1c9660b1605d723c3744db77f79dce8c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Proper test needs password input, so use error message for executable check
    assert_match <<~EOS, shell_output("#{bin}cotp edit 2>&1", 2)
      error: the following required arguments were not provided:
        --index <INDEX>
    EOS

    assert_match version.to_s, shell_output("#{bin}cotp --version")
  end
end