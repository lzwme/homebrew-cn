class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https:github.comfatedierfrp"
  url "https:github.comfatedierfrparchiverefstagsv0.59.0.tar.gz"
  sha256 "eb4848119a9684b7762171d7633aa5ee29d195e63f53e89e7b549096bdf4a5a9"
  license "Apache-2.0"
  head "https:github.comfatedierfrp.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4574f30fbaf792cd399969bb3128e27e86de0cea25d81a00d33d8f5b01390b98"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4574f30fbaf792cd399969bb3128e27e86de0cea25d81a00d33d8f5b01390b98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4574f30fbaf792cd399969bb3128e27e86de0cea25d81a00d33d8f5b01390b98"
    sha256 cellar: :any_skip_relocation, sonoma:         "5934c1c84b5d667a4758c3ead2a5cce420cfa2a310120cb19e3c22b8640b9861"
    sha256 cellar: :any_skip_relocation, ventura:        "5934c1c84b5d667a4758c3ead2a5cce420cfa2a310120cb19e3c22b8640b9861"
    sha256 cellar: :any_skip_relocation, monterey:       "5934c1c84b5d667a4758c3ead2a5cce420cfa2a310120cb19e3c22b8640b9861"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e7af61ad3008477e38da382834d221e3ea5b8d65d989d23df89e851ece4497c"
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