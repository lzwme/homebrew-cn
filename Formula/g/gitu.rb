class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https://github.com/altsem/gitu"
  url "https://ghfast.top/https://github.com/altsem/gitu/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "8d48f0c7315d6222a490d00c7baa15e9297b94258b2f18995cbab14245072972"
  license "MIT"
  head "https://github.com/altsem/gitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6eb4d6e54c074f6fa823e4ae1968546dbdf3ed650da6b3cf905f9976ffaf75cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70bf3ead35903ea4c2a1f907bed3a9dbaad947ce58e0ce1c29c11a40e8ab95ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38b2f5efbac130849b49ec0ef7a0c5494ef4bde0823a2c8e82efea6d0b46c3b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "94b537a7bfb8800346a94780fc5d82505890e7730ec54a0bdd35bf7cda18966e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c27f0c6195ef352eae9b8be483624f79fa94cba180305f85ad17e1fcde414b6d"
    sha256 cellar: :any_skip_relocation, ventura:       "84c6921fd89a5338869a896ab1ffeecc21d726a77a8d0a344880154efbdfd233"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e2c6fb4e7c84970e8410a8a27fac510ada211d6a6fd0fd5b6709f249922e94c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79fa40a025e1e97bab940c4a39b1c87538c38863adf6bb182606118c2cfe1b39"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitu --version")

    output = shell_output("#{bin}/gitu 2>&1", 1)
    if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      assert_match "No such device or address", output
    else
      assert_match "could not find repository", output
    end
  end
end