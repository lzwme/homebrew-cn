class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://ghfast.top/https://github.com/webcoyote/sandvault/archive/refs/tags/v1.1.5.tar.gz"
  sha256 "b30039e5a8a3f0c01e5c000ba58d8027c762564a6ddc27a247f2a48e59828e06"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4306fabcff3eed1d9c4455d19abb35e43b84a9daa60c30d232a258eaa0a21b8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4306fabcff3eed1d9c4455d19abb35e43b84a9daa60c30d232a258eaa0a21b8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4306fabcff3eed1d9c4455d19abb35e43b84a9daa60c30d232a258eaa0a21b8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "58e699b52d701871fe2250307e47287c59f419b48f0f70a911504a0f5a46e49d"
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