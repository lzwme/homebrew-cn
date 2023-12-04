class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://github.com/budimanjojo/talhelper"
  url "https://ghproxy.com/https://github.com/budimanjojo/talhelper/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "6abe31a5e82ef823ff49e525e4686329fa45e78e536aa4a565c9ba92849570b7"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "420f4f5258b14def2b4281a1db2736786f50c9c84abc3711ed62d216a02ca7d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "512b9b4f839520ba1c081e1547c129f0791425ea4d72344d2f2d68755b0d80b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8495595881dd2b4fba61e30800d5f1836b7b6d0a4b6e0abe00c00b4697192a36"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f6adea9341ee8ffc8f7689644722bcdc92e242ff1383cdfa23bdf4258515b6a"
    sha256 cellar: :any_skip_relocation, ventura:        "75fed29c6e74fe1b7c931834558ac13af8df995e40a8aaada1a19f1fa30224af"
    sha256 cellar: :any_skip_relocation, monterey:       "993733943ab785c0a23197a742a27b21a41bbad0fa1941b3d71518706d0e74bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afd7dd3bd6e1a23c410e43ef649d6854760fa4dd13c3fda7911a851561df36a5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/budimanjojo/talhelper/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"talhelper", "completion")
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}/example/*"], testpath

    output = shell_output("#{bin}/talhelper genconfig 2>&1", 1)
    assert_match "failed to load env file: trying to decrypt talenv.yaml with sops", output

    assert_match "cluster:", shell_output("#{bin}/talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}/talhelper --version")
  end
end