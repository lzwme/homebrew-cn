class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https:www.runatlantis.io"
  url "https:github.comrunatlantisatlantisarchiverefstagsv0.27.0.tar.gz"
  sha256 "fc0b9cfe189d66a20c6061af98cc32bd60414d6d64a6e015c528fe62a45b2e8d"
  license "Apache-2.0"
  head "https:github.comrunatlantisatlantis.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ddecb12ba5cb2dc825d3f174731aaf21ed4c9a37d59ffb46fcf0d795362bb74"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c78e69ae68ced5fc8db2e32aa429c530e7c3699412958cb6f8629b86baec7b70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "934608b155cbfa0e3a4ff07ee9311261f6c8b79c6f8855be5e340d7905b8e160"
    sha256 cellar: :any_skip_relocation, sonoma:         "d8bc372b315be91809ccd97444b5207f8cb221577d902736e2ea1c3aa4bee0eb"
    sha256 cellar: :any_skip_relocation, ventura:        "96d666713dc0a4dcd6366af1979064da7b77258b5bc18a0c3839fca832faeba3"
    sha256 cellar: :any_skip_relocation, monterey:       "0721807e188b9ea6c384a6ab2ebdf90b06cd1c73ad7f4e1cb6c8ce47a165271f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cce0fb42647cb4fd94a4269b721d3d311ca788c5b252b9a97e90d730617afa4c"
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin"atlantis", "version"
    port = free_port
    loglevel = "info"
    gh_args = "--gh-user INVALID --gh-token INVALID --gh-webhook-secret INVALID --repo-allowlist INVALID"
    command = bin"atlantis server --atlantis-url http:invalid --port #{port} #{gh_args} --log-level #{loglevel}"
    pid = Process.spawn(command)
    system "sleep", "5"
    output = `curl -vk# 'http:localhost:#{port}' 2>&1`
    assert_match %r{HTTP1.1 200 OK}m, output
    assert_match "atlantis", output
    Process.kill("TERM", pid)
  end
end