class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.52.0",
      revision: "2d3af8a108518b7a9540592735274b34d7031bf0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7ed7a53ae41369fef4393063c5d9eeb9252ae4362b9b2d8c20d57807be63417d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ed7a53ae41369fef4393063c5d9eeb9252ae4362b9b2d8c20d57807be63417d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ed7a53ae41369fef4393063c5d9eeb9252ae4362b9b2d8c20d57807be63417d"
    sha256 cellar: :any_skip_relocation, sonoma:         "a61bde75e84f00a5a95323551e2740f28dd91515121f1eabdc3ed6c6e7e38f1c"
    sha256 cellar: :any_skip_relocation, ventura:        "a61bde75e84f00a5a95323551e2740f28dd91515121f1eabdc3ed6c6e7e38f1c"
    sha256 cellar: :any_skip_relocation, monterey:       "a61bde75e84f00a5a95323551e2740f28dd91515121f1eabdc3ed6c6e7e38f1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec3c9a5c6bc7ea45c51c420770cabcc43edc2d2c837a183c3901f236f4671534"
  end

  depends_on "go" => :build

  def install
    (buildpath/"bin").mkpath
    (etc/"frp").mkpath

    system "make", "frpc"
    bin.install "bin/frpc"
    etc.install "conf/frpc.toml" => "frp/frpc.toml"
  end

  service do
    run [opt_bin/"frpc", "-c", etc/"frp/frpc.toml"]
    keep_alive true
    error_log_path var/"log/frpc.log"
    log_path var/"log/frpc.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/frpc -v")
    assert_match "Commands", shell_output("#{bin}/frpc help")
    assert_match "name should not be empty", shell_output("#{bin}/frpc http", 1)
  end
end