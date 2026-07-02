class RancherMachine < Formula
  desc "Machine management for a container-centric world"
  homepage "https://github.com/rancher/machine"
  url "https://ghfast.top/https://github.com/rancher/machine/archive/refs/tags/v0.15.0-rancher144.tar.gz"
  version "0.15.0-rancher144"
  sha256 "b7508aa1d0cd995690abf65813cff76ae3b64b2735731b0ae9e817f551a7bc7d"
  license "Apache-2.0"
  head "https://github.com/rancher/machine.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-rancher\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f76435c3175d95ee4eed404bba73573efcb09122763b97798504d47f2be007b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f76435c3175d95ee4eed404bba73573efcb09122763b97798504d47f2be007b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f76435c3175d95ee4eed404bba73573efcb09122763b97798504d47f2be007b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b0b818dbf72e003f90662cb1efae84f0321cfb13298ef2edab61b812ab4095e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "337753acf3898437de9c42ef83126aeb3e665efe1a4caffe9a9e7f160eb50885"
    sha256 cellar: :any,                 x86_64_linux:  "9ae2d72bdfd7988b492ad848604410786d03c882912b0385aea951d27c522f1c"
  end

  depends_on "go" => :build

  def install
    commit = build.head? ? Utils.git_short_head : tap.user
    ldflags = %W[
      -w -s
      -X github.com/rancher/machine/version.Version=#{version}
      -X github.com/rancher/machine/version.GitCommit=#{commit}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/rancher-machine"
  end

  service do
    run [opt_bin/"rancher-machine", "start", "default"]
    environment_variables PATH: std_service_path_env
    run_type :immediate
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rancher-machine --version")
    assert_match "VBoxManage --version", shell_output("#{bin}/rancher-machine create test", 3)
  end
end