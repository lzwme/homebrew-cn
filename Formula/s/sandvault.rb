class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://ghfast.top/https://github.com/webcoyote/sandvault/archive/refs/tags/v1.1.10.tar.gz"
  sha256 "3cfd648441e80305403b9696eb8c79d0fa9c0ee40fb1b0c0b96f2b0138537077"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "136a095d09a16f604bedadd4a35fb28a2f7a20145ef13c1ab16ea8d849882c04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "136a095d09a16f604bedadd4a35fb28a2f7a20145ef13c1ab16ea8d849882c04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "136a095d09a16f604bedadd4a35fb28a2f7a20145ef13c1ab16ea8d849882c04"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c8a9180ff8be74056fc9ca6f7078cd3693f01dd1971dfa799cf2f8ae079df1a"
  end

  depends_on :macos

  def install
    prefix.install "guest", "sv"
    bin.write_exec_script "#{prefix}/sv"
  end

  test do
    assert_equal "sv version #{version}", shell_output("#{bin}/sv --version").chomp
  end
end