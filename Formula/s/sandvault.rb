class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://ghfast.top/https://github.com/webcoyote/sandvault/archive/refs/tags/v1.1.27.tar.gz"
  sha256 "6ab4732630fdd736242fc163a2798fe05dccc5a45e47efaa58bdc5e13e3a99ac"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce237b252d1b16f0e351fe5119eb2c53197042d986567447c5a6aad68e204875"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce237b252d1b16f0e351fe5119eb2c53197042d986567447c5a6aad68e204875"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce237b252d1b16f0e351fe5119eb2c53197042d986567447c5a6aad68e204875"
    sha256 cellar: :any_skip_relocation, sonoma:        "da4430b1138fbbb88691cf54a18308f9689ec97dadbd83fa71daa2f9788d5f2c"
  end

  depends_on :macos

  conflicts_with "runit", because: "both install `sv` binaries"

  def install
    prefix.install "guest", "sv"
    bin.write_exec_script "#{prefix}/sv"
    guest_home_user.mkpath
    ln_sf guest_home_user, prefix/"guest/home/user"
  end

  def guest_home_user
    pkgetc/"guest_home_user"
  end

  def caveats
    <<~EOS
      sandvault's guest user home directory is #{guest_home_user}.
      These files will be copied to the sandvault home directory during setup or rebuild.
    EOS
  end

  test do
    assert_equal "sv version #{version}", shell_output("#{bin}/sv --version").chomp
  end
end