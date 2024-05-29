class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https:protomaps.comdocspmtiles"
  url "https:github.comprotomapsgo-pmtilesarchiverefstagsv1.19.2.tar.gz"
  sha256 "5a7a1c7815f5aa3170b5abde3fce0459215f05ee4e6c114346f69ae258be6b00"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "62783b9aabb381b5b94bce8da6119286ede49f27596f0133ef59df501cb2e84d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "629de8b8311b57517b8565a41f65427e7a62e8a38bebcfe856f64dc5865a18db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee3a039f2fa58381b5d3e7412a6ea482423a906c7bc664d39612cd6ec997b7df"
    sha256 cellar: :any_skip_relocation, sonoma:         "4771393c57be526ed8bbd119c98b72ed759ac898c1324b46e4e3b372c96c9384"
    sha256 cellar: :any_skip_relocation, ventura:        "6ea314b2440f0c48c97f4340fbe79472736822eef351518407737dd85935b235"
    sha256 cellar: :any_skip_relocation, monterey:       "0db96b8a06848dad72c39c0953328365a20698fbdb06ec542967ec09f1b6e414"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abb3ef2a33bffbe0f5c3d0f76b002369f7c31961e1feb8ab8567bd99787f0c74"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    port = free_port

    pid = fork do
      exec "#{bin}pmtiles", "serve", ".", "--port", port.to_s
    end
    sleep 3
    output = shell_output("curl -sI http:localhost:#{port}")
    assert_match "HTTP1.1 204 No Content", output
  ensure
    Process.kill("HUP", pid)
  end
end