class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://ghfast.top/https://github.com/webcoyote/sandvault/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "37d08dee036e3701bd9971adac7e425c590c872ce6b491500380df8d7bd5f05d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6db6921d02a4ac31491909c450f70978ddaa64702eb72b00512c435eea9ed7e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6db6921d02a4ac31491909c450f70978ddaa64702eb72b00512c435eea9ed7e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6db6921d02a4ac31491909c450f70978ddaa64702eb72b00512c435eea9ed7e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ac501434f1c0bb12e58771d2ba6d9d080a913739f4918bee8f7128b3b4d336d"
  end

  depends_on :macos

  conflicts_with "runit", because: "both install `sv` binaries"

  def install
    libexec.install "guest", "helpers", "skills", "sv", "sv-clone", "sv-agentsview-setup"
    bin.write_exec_script libexec/"sv", libexec/"sv-clone", libexec/"sv-agentsview-setup"
  end

  test do
    assert_equal "sv version #{version}", shell_output("#{bin}/sv --version").chomp
  end
end