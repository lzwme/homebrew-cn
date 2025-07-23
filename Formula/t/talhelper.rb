class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://ghfast.top/https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.0.31.tar.gz"
  sha256 "9a8b473de155ba525aa982cd4291f73d48c3139f023297fe2797b3a7c7e601f1"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f55c191963a9ffb4d0ae419bcc7e145040af9ada2129b7f9554e11c102633f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f55c191963a9ffb4d0ae419bcc7e145040af9ada2129b7f9554e11c102633f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f55c191963a9ffb4d0ae419bcc7e145040af9ada2129b7f9554e11c102633f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "64a043e98d0d029b87ea6920a066526649f4581089753d5e1be07ec9fb419a77"
    sha256 cellar: :any_skip_relocation, ventura:       "64a043e98d0d029b87ea6920a066526649f4581089753d5e1be07ec9fb419a77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b490f53edaa19baad2e619a4fe3cd795ec39cdf6f87e58002d29ac01f7bde681"
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