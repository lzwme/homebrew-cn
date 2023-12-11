class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://github.com/budimanjojo/talhelper"
  url "https://ghproxy.com/https://github.com/budimanjojo/talhelper/archive/refs/tags/v1.16.2.tar.gz"
  sha256 "413b3fdcd06441c93b2720bdfd3b1352b9f3472c7cb7ebf872e0aca4e6afbdf1"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a78148f3060d007f5d3b237362b410aad16620120ffb196bfea3535dfb3a1b0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84e83166d961da405b3bd6d24cc0023b5a20467ad649aee671ffd8cf0f7061b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bdce7e3897c7ba0c121fbe6e5294cf8946a35a2bbc1bd0f319aeea92fe3227f"
    sha256 cellar: :any_skip_relocation, sonoma:         "eaf1c03b18e692fc0d2561006a4b7aa58b010216ad5a485b601b1b4187042c16"
    sha256 cellar: :any_skip_relocation, ventura:        "0c4c657fa98588379c33b8f694aff68788fd8a0801c0e137de9f2aae59211332"
    sha256 cellar: :any_skip_relocation, monterey:       "6979b3042017e429c35a1e5100029b4a408fd61221341abd58325ccfb1e1f0c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8eea65eae46c957b4df7555de89f8fbaf985d57d59afc8bab3e75f99e4a3fd4"
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