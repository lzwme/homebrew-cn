class Dnote < Formula
  desc "Simple command-line notebook"
  homepage "https://www.getdnote.com"
  url "https://ghfast.top/https://github.com/dnote/dnote/archive/refs/tags/cli-v0.15.4.tar.gz"
  sha256 "01851bdd304c05a2ed71ed0d21a6d1cd641aaa5ef6cb44ea95d6e8d035b0a76a"
  license "GPL-3.0-only"
  head "https://github.com/dnote/dnote.git", branch: "master"

  livecheck do
    url :stable
    regex(/^cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7a27e016907ff0ac3bf002e36afc40a48ac24930de58c6759904eb1667b92ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dacadf075936b1cc9546ce79a38341102111afcdec359f733d34aafcb4b1003c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34ef973173f1d28d845e803947b9edf235193646bf6fcd7a76eb0d743907bc75"
    sha256 cellar: :any_skip_relocation, sonoma:        "a852c931ae46f02d02e39b86989d67bbe58011c77d30c7d82170558bcdb9de33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6aaed89de5ae016de6e7c5ec2f9afa6ef1d7d2a5a3eb7534852618af9a535b9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68b82678228b037da6a663be740b21421419e6c287751ca97187e2f9be3603a5"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

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