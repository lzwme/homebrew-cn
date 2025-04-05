class Gurk < Formula
  desc "Signal Messenger client for terminal"
  homepage "https:github.comboxdotgurk-rs"
  url "https:github.comboxdotgurk-rsarchiverefstagsv0.7.0.tar.gz"
  sha256 "55cdac0b67db51f6257d2f04d5513ed5c79bb70752dc219fb38b80ff73d9d346"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a0f22641ac4619a14b67cc3525a188c481b728206c5afe3d14fb86102fddffc6"
    sha256 cellar: :any,                 arm64_sonoma:  "80cdcd4bb559b73ff355bfdaec377afff1e8e66c659c0df7b2237653405dcd17"
    sha256 cellar: :any,                 arm64_ventura: "ef02f99eddf9cb680723e2be2b42998d6a6949cdd4984ba6d4bf3a701d182859"
    sha256 cellar: :any,                 sonoma:        "840559921333329b0a19caea7b57717237c541dad382b9114ebeafa8fbcd3a2b"
    sha256 cellar: :any,                 ventura:       "a67d1cb1178949aa92872d657e367e26af2159b24767ea1e376ba28af023a847"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33596d49e1f9d43d51b5dcdae8d2d6ad9427203a616d3bae2bd56c2b42cafa5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b57471c3e86661e6124f1e01954456f84eb65f03c1bdfe44f3fad11249a9694"
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
    assert_match version.to_s, shell_output("#{bin}gurk --version")

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath"output.log"
      pid = spawn bin"gurk", "--relink", [:out, :err] => output_log.to_s
      sleep 2
      assert_match "Please enter your display name", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end