class Cotp < Formula
  desc "TOTPHOTP authenticator app with import functionality"
  homepage "https:github.comreplydevcotp"
  url "https:github.comreplydevcotparchiverefstagsv1.7.3.tar.gz"
  sha256 "d054e9681066be8b7859af47bba4bfd51744f81732974b115997f2677fded045"
  license "GPL-3.0-only"
  head "https:github.comreplydevcotp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fcfa73cd6cb6ad016573d19d30bb6115dfec76309adefa094a2bca7ce5880620"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc5cf105cca6be108be930d1df940df4ca29bc42a2d232b7726e57ff11278009"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71acb1ef1d1cb0fe525bd8b4f9c38ac35507af4168b0a41fde3825714f12cefe"
    sha256 cellar: :any_skip_relocation, sonoma:         "03694802c6a86f97d25d1833216b73842111be7e671e7bb6131f93c92d5d6a5f"
    sha256 cellar: :any_skip_relocation, ventura:        "c1d7033ced818f9858753c137cfac1a23b84ade9e2c27591ac75022292a9856b"
    sha256 cellar: :any_skip_relocation, monterey:       "8851c98d468ba76648b8bf28f1674d7b9799ef41736efd50ea163dccfc9787ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98c4d82455fa7098a1eee36968f5a83c310f54816e29644612970f4cb6f9308d"
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