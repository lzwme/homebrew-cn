class Dnote < Formula
  desc "Simple command-line notebook"
  homepage "https://www.getdnote.com"
  url "https://ghfast.top/https://github.com/dnote/dnote/archive/refs/tags/cli-v0.15.2.tar.gz"
  sha256 "d68fd975a91b1872d15c2bfea12a1b43d8878c9811d1df4876c07f3d10f05e4e"
  license "GPL-3.0-only"
  head "https://github.com/dnote/dnote.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca0d5c2c89e54661d1acef6bec74aa22397755e502d0d692c7e355d002493f69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a1d3d6358a11edae43465a046927690efbd591b87b71a2cbbe78bde802c7c2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8a29c44a56d826dca695c3307f46ebd784ad44d7c93d48b5248b8d678976c8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f49a252c80178c5dc230dc95cfa45b4a34e748cf91ced442c1c5e9aa0e50a1d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15995657c95db000067ad4ad84586da2219c67af8b485b8bf9f95e3db03c1506"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1874739a52c05c5c86480cce7c5a4e2e3ecf43f18858a5de403c74fe37264c93"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionTag=#{version} -X main.apiEndpoint=http://localhost:3000/api"
    system "go", "build", *std_go_args(ldflags:, tags: "fts5"), "./pkg/cli"
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath
    ENV["XDG_DATA_HOME"] = testpath
    ENV["XDG_CACHE_HOME"] = testpath

    assert_match version.to_s, shell_output("#{bin}/dnote version")

    desc = "Check disk usage with df -h"
    system bin/"dnote", "add", "linux", "-c", desc
    assert_match desc, shell_output("#{bin}/dnote view linux")
    assert_match desc, shell_output("#{bin}/dnote find 'disk usage'")
  end
end