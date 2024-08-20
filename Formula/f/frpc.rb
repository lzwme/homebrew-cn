class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https:github.comfatedierfrp"
  url "https:github.comfatedierfrparchiverefstagsv0.60.0.tar.gz"
  sha256 "8feaf56fc3f583a51a59afcab1676f4ccd39c1d16ece08d849f8dc5c1e5bff55"
  license "Apache-2.0"
  head "https:github.comfatedierfrp.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef0ad7eceed7fb8dd4bea309eec8da365e12f53a5ffae9411fc39dc0ca0e2ad7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef0ad7eceed7fb8dd4bea309eec8da365e12f53a5ffae9411fc39dc0ca0e2ad7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef0ad7eceed7fb8dd4bea309eec8da365e12f53a5ffae9411fc39dc0ca0e2ad7"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9c8f0db6e6f5c6a406e9b8088c7dbf135a6d08024cd82a053dbd940b037e179"
    sha256 cellar: :any_skip_relocation, ventura:        "a9c8f0db6e6f5c6a406e9b8088c7dbf135a6d08024cd82a053dbd940b037e179"
    sha256 cellar: :any_skip_relocation, monterey:       "a9c8f0db6e6f5c6a406e9b8088c7dbf135a6d08024cd82a053dbd940b037e179"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc2b35261551236ff961abc8bc3bfd30b81e85f253896310bbbdcef9c1179b43"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags=frpc", ".cmdfrpc"
    (etc"frp").install "conffrpc.toml"
  end

  service do
    run [opt_bin"frpc", "-c", etc"frpfrpc.toml"]
    keep_alive true
    error_log_path var"logfrpc.log"
    log_path var"logfrpc.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}frpc -v")
    assert_match "Commands", shell_output("#{bin}frpc help")
    assert_match "name should not be empty", shell_output("#{bin}frpc http", 1)
  end
end