class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https:github.comerebewstunnel"
  url "https:github.comerebewstunnelarchiverefstagsv10.3.0.tar.gz"
  sha256 "ede8dfb23fbab3ed5090a256ea79290c036b04e3312b8ad487d47bc5e71ff570"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a6cf8987b383e34be36f8edd410285113f335e45298dfe8793972ee9fd50c13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a122452ab5d4b180d80d724942910802026d8319d1dd0a9eb06bd1e39d18244a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "58cc16dfd1eb40a0f4c5a131f1baf96098b76ffd9f2e9a0120a8aa9f4ad88b5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fe8ae254394d5c4cbc8c8ee50b52b6753c1b560cdcc18b09e5c8276a345cbe1"
    sha256 cellar: :any_skip_relocation, ventura:       "3fc4bcb8ec223b9215c38062eb98870dafa6023db6198a6d7f196da17b0cb79d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a94291e5ddd138b46255f4495ddc0b7fbf3e2b1b8a6082abb1706ce8d7170c75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c24dd1a9d46fb302d5397fb5707833bc4b6024e8a857f7f1fbea5d728a12700"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "wstunnel-cli")
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