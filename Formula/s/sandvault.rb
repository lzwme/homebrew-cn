class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://ghfast.top/https://github.com/webcoyote/sandvault/archive/refs/tags/v1.1.20.tar.gz"
  sha256 "19c213d5cf47d384d8c9a7a965a24a1101ff0bdc8418d4a9558e573bbe81ed49"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e079938efc757c77aeb9fa883f3fa201334acbf3828346bdb65af945edd86df3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e079938efc757c77aeb9fa883f3fa201334acbf3828346bdb65af945edd86df3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e079938efc757c77aeb9fa883f3fa201334acbf3828346bdb65af945edd86df3"
    sha256 cellar: :any_skip_relocation, sonoma:        "a808df640848e668801008ac2a2b99c746b4a27c8b16269ecd427f6ddc10b938"
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