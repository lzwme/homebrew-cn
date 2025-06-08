class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https:k6.io"
  url "https:github.comgrafanaxk6archiverefstagsv0.20.1.tar.gz"
  sha256 "db0af1b8969e307a531b362039fbfb030a568de17763a6825195d958c73352bb"
  license "Apache-2.0"
  head "https:github.comgrafanaxk6.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e20d80d6dce1d8d3fe65f5f09d709c01c20a87aab6590f4cc10edbb3fea3e1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e20d80d6dce1d8d3fe65f5f09d709c01c20a87aab6590f4cc10edbb3fea3e1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e20d80d6dce1d8d3fe65f5f09d709c01c20a87aab6590f4cc10edbb3fea3e1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a0a0f3825ef3f80275ec37a02f0321b57a84605c06c683e69d296c04335c02e"
    sha256 cellar: :any_skip_relocation, ventura:       "1a0a0f3825ef3f80275ec37a02f0321b57a84605c06c683e69d296c04335c02e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "954dc78481339ce43e2da09648d31a2bf739c77f74817173ae8b43009d280b72"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X go.k6.ioxk6internalcmd.version=#{version}")
  end

  test do
    assert_match "xk6 version #{version}", shell_output("#{bin}xk6 version")
    assert_match "xk6 has now produced a new k6 binary", shell_output("#{bin}xk6 build")
  end
end