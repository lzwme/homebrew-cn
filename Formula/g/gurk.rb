class Gurk < Formula
  desc "Signal Messenger client for terminal"
  homepage "https://github.com/boxdot/gurk-rs"
  url "https://ghfast.top/https://github.com/boxdot/gurk-rs/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "859f0583492ebf302988102fc1c2051a7df57d626b4408b73d78ac064296f067"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "566681166b4ae1baec8fd5bdd3f3e01c8ef68e908b38acb8b5d970c994180d9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b51330161a12aa73f0167e78b71896e6e7dff35d767718c702b6c4b63c6662b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bc59d3fd989fb47825afcfe21dc431589a6c5607725fac91e3fd54bc8d8c354"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d89c8c3bb300ad30d2e3307d427aa7e6b539a3d9f796ba6c05022f1e07ee2dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48a587abb83c9eedd0c95eb70b9682809c4a402dffe194ee8182e7f143bd5d68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6028220297161ec4db56f58d7914eee47e37ec2d657307b997f59f4db2026c4"
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