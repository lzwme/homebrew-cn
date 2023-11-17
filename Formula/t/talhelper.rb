class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://github.com/budimanjojo/talhelper"
  url "https://ghproxy.com/https://github.com/budimanjojo/talhelper/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "91b577f0d0d45eb921ae71ba201ec69aaa7d81a4d789ae978a88444341056678"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b4bc9252b6bc9454d4f0ede4cb91b3bfc8a4c54008c9daab2b12afe3f8c72361"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d140bc300132be8f0e074241068603dce815c2657176dcb90bfbf36b2618009"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "458411b6a96c806280abfd6ebd1d64e819cd1afbed01a1c0bc4a4baf1a87941c"
    sha256 cellar: :any_skip_relocation, sonoma:         "77bbe53453ba56b0bb68bf54967466329787e0528354f8a54058ee2bd7bb6aaa"
    sha256 cellar: :any_skip_relocation, ventura:        "7e74d5d0b43001a910f1d4b2191ec2a4bfd9152851911447e918dc8e036d3634"
    sha256 cellar: :any_skip_relocation, monterey:       "0a7adaaa832bcd7ecf0c616e1eb6229f910debcd07b3cc7ba55a63a4b4b32347"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "491a1194b3a27e553473ab264d788e2a2463b6db0e0a029aafd134b65937e334"
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