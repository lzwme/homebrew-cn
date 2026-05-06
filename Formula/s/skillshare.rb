class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.19.7.tar.gz"
  sha256 "83a0c08f2bd6509124b8a578d76f67e56fc8b0e3d05a12bd810f0ecc0f6b831d"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb3f6fb2024c64ac09be6b8153f8e459b58cefd475eef69958c6169280247158"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb3f6fb2024c64ac09be6b8153f8e459b58cefd475eef69958c6169280247158"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb3f6fb2024c64ac09be6b8153f8e459b58cefd475eef69958c6169280247158"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9cc2bd4388728cd156a58f2ef66351d4e8f678b27b6b36a667b361629f04664"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d907b149de463702ad2a9c77a63f66bcc10252b4df3509ea5039ee80d71d8afb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66bff1a56adca5f82dc69d8a8b4486bcbfb4649fb4290dc0ed29ce838250eeef"
  end

  depends_on "go" => :build

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end