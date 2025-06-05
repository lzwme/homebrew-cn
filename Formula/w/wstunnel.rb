class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https:github.comerebewstunnel"
  url "https:github.comerebewstunnelarchiverefstagsv10.4.2.tar.gz"
  sha256 "dd421991399dbab1261a339958d0af77ec94d1a20f4faec1d8fd40bead0b8594"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79dc95155b17874b57034280388e39179fd39660f4903357da04c4453408f0d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f216a070be70662bb18cf370e2e766daca6c093ba874ede8ce14c12de54975a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f912eb616678d51adc7f7c2f10227e31cb33605d2e741d7a4b5392ea71d57562"
    sha256 cellar: :any_skip_relocation, sonoma:        "93fedd35f9be4077f18f89150f0dd584b3f61264f221bfebf76bc776fd44b82c"
    sha256 cellar: :any_skip_relocation, ventura:       "62b5af8204fa9157cdcd6c35e3a0133dbd08bfa8f8bfa3393e209dc086fb0bd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e20cc2d0a8efe17a287ecabbaed0d00120cde54126d4c6b82a31de2d2b79352f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c243eba3b9c7e3263ba7067126ce435d3da1e47048a06aba621c8324c1d9ea2"
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