class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https:danielmiessler.compfabric-origin-story"
  url "https:github.comdanielmiesslerfabricarchiverefstagsv1.4.216.tar.gz"
  sha256 "7ffb1742cf032b712142ee96fc1dbb8c9e4347e1681e0af2578ccfb9689e22c4"
  license "MIT"
  head "https:github.comdanielmiesslerfabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cedb2fe4281918ddc13da63e297d47ae699e89010e4b79e9ad3bb6ffb86924f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cedb2fe4281918ddc13da63e297d47ae699e89010e4b79e9ad3bb6ffb86924f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cedb2fe4281918ddc13da63e297d47ae699e89010e4b79e9ad3bb6ffb86924f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "0731d2aa17cc0e9057d2d119f2c4c75ce070d8f8a8450e1ce52ac99fea10cffb"
    sha256 cellar: :any_skip_relocation, ventura:       "0731d2aa17cc0e9057d2d119f2c4c75ce070d8f8a8450e1ce52ac99fea10cffb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd7ccffc9bf88e6244787cd153905935e170f5f42325f01767620205f66e3c6c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}fabric-ai --version")

    (testpath".configfabric.env").write("t\n")
    output = shell_output("#{bin}fabric-ai --dry-run < devnull 2>&1")
    assert_match "error loading .env file: unexpected character", output
  end
end