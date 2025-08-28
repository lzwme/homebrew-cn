class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://ghfast.top/https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.0.33.tar.gz"
  sha256 "df47b99f929e23eb264b2665d09c2e1daacb45513be432482d50380b37801106"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18228e4beb9a3e2c5de9ac4b300c93e52ea736dedf35508f4062d1f4f5563f14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18228e4beb9a3e2c5de9ac4b300c93e52ea736dedf35508f4062d1f4f5563f14"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18228e4beb9a3e2c5de9ac4b300c93e52ea736dedf35508f4062d1f4f5563f14"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7c827655facc5ed3a3c21389e60d3767a2bc335ce5cbe76905c36f2e1c83194"
    sha256 cellar: :any_skip_relocation, ventura:       "b7c827655facc5ed3a3c21389e60d3767a2bc335ce5cbe76905c36f2e1c83194"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6792b1c9aff7839da41f10907e288672c4a2bc1e6c50bfbf8ded05b24867833d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/budimanjojo/talhelper/v#{version.major}/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

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