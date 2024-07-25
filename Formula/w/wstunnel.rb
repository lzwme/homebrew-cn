class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https:github.comerebewstunnel"
  url "https:github.comerebewstunnelarchiverefstagsv9.7.4.tar.gz"
  sha256 "b18e01f34036073ae0e6f68053cf5f131dbb781932e8566dc63efbed0732b335"
  license "BSD-3-Clause"
  head "https:github.comerebewstunnel.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "548040edbbe5374bccf2ade1ea957a1817f90b9f21bc1185bc483ec09ca00419"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "043dc537ee83a23fe0eb7a423655daec58b5992d5c1faaabbbdacc515505be88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f7446e1731ceaf61a04cbcc3c7079f91d320d9c7f6ad53a8bbb31620745b66d"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f3013814810ceec4e5a09243ef18e5a02c0ce55a974d954178ee5615f5ccb05"
    sha256 cellar: :any_skip_relocation, ventura:        "1a34526be748b2889b1780b43bd82b56a346b6da830c23d58730d0cebf58206a"
    sha256 cellar: :any_skip_relocation, monterey:       "3fd9fb87c223752825b54b8763aa788c2878415d5777f5e97274b59d6d48f8b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8834bf0a4916e22981c41f1440a2af542410dea2f513d72f656d10788677d61f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["NO_COLOR"] = "1"

    port = free_port

    pid = fork { exec bin"wstunnel", "server", "ws:[::]:#{port}" }
    sleep 2

    output = shell_output("curl -sI http:localhost:#{port}")
    assert_match "HTTP1.1 400 Bad Request", output

    assert_match version.to_s, shell_output("#{bin}wstunnel --version")
  ensure
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end