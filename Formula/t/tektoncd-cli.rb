class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https:github.comtektoncdcli"
  url "https:github.comtektoncdcliarchiverefstagsv0.35.0.tar.gz"
  sha256 "4962991ea4f2dc55b27a12132bf8828f87eb8ba38df472ffba8c31c24ca054ba"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "257eb0ffcc9ecf9b340dfda3d77d22a83f6e7febd7d3628c90599087dd6a632b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b92e76298cb07c51c78140b39fc7dc2e2a7484f7f22016219263e19f2e7c9884"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c496496e26114232c802b8fb20c22a3d56dabd5898093dfbffaaf9601b6d28dc"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a6be059985cadacb37098a9616d7219fadc648414528935a4eba5ad6ef8f537"
    sha256 cellar: :any_skip_relocation, ventura:        "4563a2ba5175c4847d623aaebcdacf7b0ef8776f88c78ac5359c4696857cee52"
    sha256 cellar: :any_skip_relocation, monterey:       "e61af0afb7c0054101eced11ab6665346ed76cd75ab7f09158bb4c3835840e19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3404709fd5cf23ce425554d057a01cdeb21cf00a52604be98f654140808b0c7"
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