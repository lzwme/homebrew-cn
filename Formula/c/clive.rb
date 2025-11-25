class Clive < Formula
  desc "Automates terminal operations"
  homepage "https://github.com/koki-develop/clive"
  url "https://ghfast.top/https://github.com/koki-develop/clive/archive/refs/tags/v0.12.14.tar.gz"
  sha256 "c4867473f8f590bb1ff663297184d24b725917d8166e0212d2500f3377b64c9f"
  license "MIT"
  head "https://github.com/koki-develop/clive.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2d71b0d1b05e6b6c09868737a60c050131fd0c767e3f4ffe85ecaa257a5616e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2d71b0d1b05e6b6c09868737a60c050131fd0c767e3f4ffe85ecaa257a5616e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2d71b0d1b05e6b6c09868737a60c050131fd0c767e3f4ffe85ecaa257a5616e"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e1fc445fafc0787bebc5ae37e97d3328d56dc862a1a955078a6cb5a5ebbb6f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8ea017327fe4cc27530d2b70ce15bffabb0b440bd99efcafc6bd47b56ae1eae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b770a84fbd1e6a60e3f07649effd1f73933d864b4a99bb4cfc595b5f2b29ff5"
  end

  depends_on "go" => :build
  depends_on "ttyd"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/koki-develop/clive/cmd.version=v#{version}")
  end

  test do
    system bin/"clive", "init"
    assert_path_exists testpath/"clive.yml"

    system bin/"clive", "validate"
    assert_match version.to_s, shell_output("#{bin}/clive --version")
  end
end