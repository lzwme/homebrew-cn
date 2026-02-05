class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://ghfast.top/https://github.com/webcoyote/sandvault/archive/refs/tags/v1.1.18.tar.gz"
  sha256 "9fdf274b147e3d4f143cfd220cc903fdebf3d955c30e0ae5a63dda77447a439f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80dd7b54031efb6b97c8780a84174a54adee37a563e274e366a839fb791a085f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80dd7b54031efb6b97c8780a84174a54adee37a563e274e366a839fb791a085f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80dd7b54031efb6b97c8780a84174a54adee37a563e274e366a839fb791a085f"
    sha256 cellar: :any_skip_relocation, sonoma:        "71d5c0f73b32bc1f386ae8054ce0701644eebe133d860210c3997d435b26e5d4"
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