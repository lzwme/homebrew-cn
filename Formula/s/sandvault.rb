class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://ghfast.top/https://github.com/webcoyote/sandvault/archive/refs/tags/v1.1.23.tar.gz"
  sha256 "f03e4b89eed37e69b589b1fa49659e5dcceade47c7fedfdad9c1d169c09112f0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4c1dc32dc66e6b9a82fa3b46ad83fafe955e9969a02903b8e0ec4e3e865b420"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4c1dc32dc66e6b9a82fa3b46ad83fafe955e9969a02903b8e0ec4e3e865b420"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4c1dc32dc66e6b9a82fa3b46ad83fafe955e9969a02903b8e0ec4e3e865b420"
    sha256 cellar: :any_skip_relocation, sonoma:        "fba63c282fbb00a28afb0cb054c555d819f98eebc22efaa704d545d1cf60230a"
  end

  depends_on :macos

  conflicts_with "runit", because: "both install `sv` binaries"

  def install
    prefix.install "guest", "sv"
    bin.write_exec_script "#{prefix}/sv"
  end

  test do
    assert_equal "sv version #{version}", shell_output("#{bin}/sv --version").chomp
  end
end