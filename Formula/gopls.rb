class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://ghproxy.com/https://github.com/golang/tools/archive/gopls/v0.12.0.tar.gz"
  sha256 "4fd15bafcb73aa280eedd6edcb2296d1a26306f5e9ec6c10dec60626ecfe11bb"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{^(?:gopls/)?v?(\d+(?:\.\d+)+)$}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1bf51412a43770df9b3d6bc5e2733d71c9d20403da582cefb132da1d74ef641b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46eb60f2e8a9294a59c3e0da92ae048bc28fe19f0a10f91edd16f35a9bfef421"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "437df60d11872bc25c5703adc31c57322aa88ccd6ee67d473e9a8491a6ce6387"
    sha256 cellar: :any_skip_relocation, ventura:        "15b52f6ed7c2f0f3eb69c7bd1158384c0a6a15b380620a10f85bb98624daf29b"
    sha256 cellar: :any_skip_relocation, monterey:       "74a3049b8285c8c80ffede8f9f32eb47bac62b46629d5330eb37a25b8d5a6955"
    sha256 cellar: :any_skip_relocation, big_sur:        "4845b06082fa7160bbe096355898db97b958b3d856def749ddbe6b8e425313a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4447e912ac67e0fdb0007b5ba2ee9716c17e4bb7a5c7e10fe7a3e5c639cf95b5"
  end

  depends_on "go" => :build

  def install
    cd "gopls" do
      system "go", "build", *std_go_args
    end
  end

  test do
    output = shell_output("#{bin}/gopls api-json")
    output = JSON.parse(output)

    assert_equal "gopls.add_dependency", output["Commands"][0]["Command"]
    assert_equal "buildFlags", output["Options"]["User"][0]["Name"]
  end
end