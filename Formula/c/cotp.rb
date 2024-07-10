class Cotp < Formula
  desc "TOTPHOTP authenticator app with import functionality"
  homepage "https:github.comreplydevcotp"
  url "https:github.comreplydevcotparchiverefstagsv1.7.2.tar.gz"
  sha256 "0293483ef7a6671901fbe8fb228a334ae4fa9c9c579c9fae7a112f6efd04ae53"
  license "GPL-3.0-only"
  head "https:github.comreplydevcotp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "42618ced4b4e8891c7ea11c3fff5b6d44c9ad54c2fc6c0c48c38047246ad6b70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4d768f289bedb144cc392367f369609375cca008b4a2e97aa76ed6d00f06d9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f40b1f9cdee1d5225b9a5451f71bebf173b5ea5c718ed1a8653b506def1ccbf8"
    sha256 cellar: :any_skip_relocation, sonoma:         "5bc292affc1e8e59cda9d2e4d76bef9ad3ff04269a1e4db17b53a23491df07a6"
    sha256 cellar: :any_skip_relocation, ventura:        "fcd4371a197e161ca75ea88f9e9f1a4d8f55bfe606b7d3dbde9a04c744943b19"
    sha256 cellar: :any_skip_relocation, monterey:       "be51777e4a2b707ea48d0a2ad4edc08a75434740096ba35225950b79b0160150"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d6414419d4989dc269217e4c546fdc2c5e2e88f4c980af156b4ae2c45098e31"
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