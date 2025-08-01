class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://ghfast.top/https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.0.32.tar.gz"
  sha256 "1686d71ce12769e1ab9a67e5d3ae96aefc30d08f49185960b84c610787c2534e"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfaedd7c23a320ffb6f7250b09358e617824cd1becfb549a8f1dcde450a29ec0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfaedd7c23a320ffb6f7250b09358e617824cd1becfb549a8f1dcde450a29ec0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cfaedd7c23a320ffb6f7250b09358e617824cd1becfb549a8f1dcde450a29ec0"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f9e2a6fae8e9a1c1c15e6e09e5ecb080db3045404e6deb164bd4653d5fcfff7"
    sha256 cellar: :any_skip_relocation, ventura:       "9f9e2a6fae8e9a1c1c15e6e09e5ecb080db3045404e6deb164bd4653d5fcfff7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "313854ed3e32221c8bce230b562158096aa92ba544430e4f57ea169b6ad3b505"
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