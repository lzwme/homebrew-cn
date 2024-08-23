class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https:github.comtektoncdcli"
  url "https:github.comtektoncdcliarchiverefstagsv0.38.0.tar.gz"
  sha256 "e3970edde44c07d3d86fd341368f626b037141a4d3511411cddb75f416f26355"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "805e2907d0a2e2e31714a77709b8cb5112646356daa6e80ee5b26d64dc76fd80"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70317b4c6089b2d19bb0590c4d4e666103fc763b40f513be3c9789d12c393d04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c480041c9b6f88c1f01ebbaef5e5fa1260792277a07fe4a720fdd4386988be62"
    sha256 cellar: :any_skip_relocation, sonoma:         "633c5e04ae9735949b90bd3182e88d3b6a041200f47c7021fcaac903baeef793"
    sha256 cellar: :any_skip_relocation, ventura:        "53636a84a5a4ddb48109fb3958296d65ac8b2b7e270c1e7663495873a9fcce6d"
    sha256 cellar: :any_skip_relocation, monterey:       "d37b8d280d8008450a19f0df09580bd5cd6a4c4abc3dab7a2bf4f48f9d6ca209"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8139dada9363c5fb1bc304583c0aba2ffbc54bf4089a1a2f1fdb5944705848e"
  end

  depends_on "go" => :build

  def install
    system "make", "bintkn"
    bin.install "bintkn" => "tkn"

    generate_completions_from_executable(bin"tkn", "completion", base_name: "tkn")
  end

  test do
    cmd = "#{bin}tkn pipelinerun describe homebrew-formula"
    io = IO.popen(cmd, err: [:child, :out])
    assert_match "Error: Couldn't get kubeConfiguration namespace", io.read
  end
end