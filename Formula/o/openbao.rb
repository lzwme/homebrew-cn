class Openbao < Formula
  desc "Provides a software solution to manage, store, and distribute sensitive data"
  homepage "https://openbao.org/"
  url "https://github.com/openbao/openbao.git",
      tag:      "v2.3.2",
      revision: "b1a68f558c89d18d38fbb8675bb6fc1d90b71e98"
  license "MPL-2.0"
  head "https://github.com/openbao/openbao.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1346e8b7c84706a5680380f587bb50c09e32300f690a66f9392bb4d5cdafec30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8225e7cfb606eb43ec484a7aa333a0ca68c81d1416d9b0cb549bc5c1346b3871"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "daa65fb3f8b725920a2bea53d568856f87f19ca0d48f65d3746bd077dd4157a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9f2dc665af2f6ec088db8321bb13c8b5a006111a19cab82a36dc8b3259859fb"
    sha256 cellar: :any_skip_relocation, ventura:       "cc1843c744f7050133349036b00ff65ab86684a61485f2926d647f4aa9a85089"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2616b830e3ff0fe85f5b5cfe7df1dff6fe1c7b169d3146dbea3b63b0b97b94d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79655ba5cd3d677624206e6b4ed7594d484bc4c20b2a2671f207ba8ce336a4d0"
  end

  depends_on "go" => :build
  depends_on "node@22" => :build # failed to build with node 23, https://github.com/openbao/openbao/issues/731
  depends_on "yarn" => :build

  conflicts_with "bao", because: "both install `bao` binaries"

  def install
    ENV.prepend_path "PATH", Formula["node@22"].opt_libexec/"bin" # for npm
    system "make", "bootstrap", "static-dist", "dev-ui"
    bin.install "bin/bao"
  end

  service do
    run [opt_bin/"bao", "server", "-dev"]
    keep_alive true
    working_dir var
    log_path var/"log/openbao.log"
    error_log_path var/"log/openbao.log"
  end

  test do
    addr = "127.0.0.1:#{free_port}"
    ENV["VAULT_DEV_LISTEN_ADDRESS"] = addr
    ENV["VAULT_ADDR"] = "http://#{addr}"

    pid = spawn bin/"bao", "server", "-dev"
    sleep 5
    system bin/"bao", "status"
    # Check the ui was properly embedded
    assert_match "User-agent", shell_output("curl #{addr}/robots.txt")
  ensure
    Process.kill("TERM", pid)
  end
end