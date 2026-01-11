class Gurk < Formula
  desc "Signal Messenger client for terminal"
  homepage "https://github.com/boxdot/gurk-rs"
  url "https://ghfast.top/https://github.com/boxdot/gurk-rs/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "8254e7aae79d1d1e79a543965c9f44624a817e9cbc0cd8eee973fd3118b3af26"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f89e5c54aeb34f6a3878cbd36179b6fd311457db6b5464fd453bb03c1ac16579"
    sha256 cellar: :any,                 arm64_sequoia: "b52bd87d7a51c556dc2d1e8f4ea6fe7fcb6eca351cc2aecd365f12ebe516a008"
    sha256 cellar: :any,                 arm64_sonoma:  "e78ba88a862ea96456f0f2ba5f0b2049321fc9e97f37a43533c46926b8b80a31"
    sha256 cellar: :any,                 sonoma:        "6ef0b8d129796d0b4c4f0b07c8bc9f1706f31174073fb3e10ba9d266d8afa01a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d23f21211c22e078b0e0d9422c58bc952955e0d49a1652fa114ebcbc9c216d7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2951a701af60d7be93f871d6c21d6cd4c8b7cda69b1274379242ddb4de74d25"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gurk --version")

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"gurk", "--relink", [:out, :err] => output_log.to_s
      sleep 2
      assert_match "Please enter your display name", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end