class TryRs < Formula
  desc "Temporary workspace manager for fast experimentation in the terminal"
  homepage "https://try-rs.org/"
  url "https://ghfast.top/https://github.com/tassiovirginio/try-rs/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "25532f8b1dc97c15c3bafe6eed30ce197d26b68116b0b888ac1a9930e9825f11"
  license "MIT"
  head "https://github.com/tassiovirginio/try-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "287e8341d80e05f18d2d9b0b8c404af0517c1c5d42816df75250266c93aa7b82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e1b1090be3b1b5d43275e5988a9b9331fc070660334c01dd3f962b68cd5e740"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff4dc939eab7f02d9f56407ca56d93106c64473c12ef36ef849004041b36eaf2"
    sha256 cellar: :any_skip_relocation, sonoma:        "e983be0d1d5f3aaba9321b0b41150aa5a24255020971d4b0cc588013b3762d30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af92369dda75d0c73d61284c18690e8808e1851b1fcee3dfeb2ee0d46a4162ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23e0ee141fc62f44869cb5d01c4e6796397adaa462e8952d8a3a23efaccc5f93"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/try-rs --version")
    assert_match "command try-rs", shell_output("#{bin}/try-rs --setup-stdout zsh")
  end
end