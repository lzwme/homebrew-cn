class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https:zellij.dev"
  url "https:github.comzellij-orgzellijarchiverefstagsv0.41.1.tar.gz"
  sha256 "72db7eb7257db08f338f37f0294791ea815140f739fbcb7059ccb0c8165a99d3"
  license "MIT"
  head "https:github.comzellij-orgzellij.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4024ec01b2ecbddffd2b8bf347dad1d9dc7d724541250ec4441b6350c2b731d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18c1fd0c345b1369e6f3858e22e0e19068c889ff7e57836e90c141594a143b4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ebdb501fe9ce349c8ce222f8f9486015263701893ab851b09b8be02d41d3962"
    sha256 cellar: :any_skip_relocation, sonoma:        "f396acab596bf67b1eef80648f62be784567d33b6ea298a2df09dcfeacd27ef4"
    sha256 cellar: :any_skip_relocation, ventura:       "62f6feb27ebdd6d1aed0932bb526a57d0b307c00f3f33713b6cdc2e6a6193d8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dba5e8cc8b6eac93934205f3bae3dd96128d1370a06250027a7fac2a53b441e3"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"zellij", "setup", "--generate-completion")
  end

  test do
    assert_match("keybinds", shell_output("#{bin}zellij setup --dump-config"))
    assert_match("zellij #{version}", shell_output("#{bin}zellij --version"))
  end
end