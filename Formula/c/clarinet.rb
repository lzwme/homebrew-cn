class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://stackslabs.com/"
  url "https://ghfast.top/https://github.com/stx-labs/clarinet/archive/refs/tags/v3.12.0.tar.gz"
  sha256 "8b1b126b87e6aa86d24d8d8d52df969d9112eb010bf59c6e89e2c5be0f6e46e7"
  license "GPL-3.0-only"
  head "https://github.com/stx-labs/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a3d08a3f1a926caa1785eb316fe0eecbe5725c08a391e6a19d544d78712b3dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87df79ca929ee844cca7d68b4e249e587e0ac9e2ecd20b8bceb6e2b745b2007e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb45b0887a9fc863c945b6c6919d39b3a90b7b5fb048479c34fe65e904acc05c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0df6ef6ec7f7a384c563eefb3806f441ada7b25a6f66dade0c3ee04eec9cf632"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efcda8a9575d43a9cb59547769b7da53f837872919ce7ec8f0f76d6c380bf20b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80664ca601b2c4c32e4ce6af8db26cfc32f241df2ca4e0ee56e96437eba02caf"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "components/clarinet-cli")
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end