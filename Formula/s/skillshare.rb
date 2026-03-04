class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.16.9.tar.gz"
  sha256 "8ab6ce3b586ae94aa7a38907948a2ddd1d9a5ea633c738750f0ef9523631cdfc"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c5eb0d4acb9cc74a1c50715f36d07e6127d414cd62f3f9ba9e752dbe2e25ca7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c5eb0d4acb9cc74a1c50715f36d07e6127d414cd62f3f9ba9e752dbe2e25ca7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c5eb0d4acb9cc74a1c50715f36d07e6127d414cd62f3f9ba9e752dbe2e25ca7"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec2e71895369f16bec59fefcfbb985a7b2ba551e34f6c08d56bdb9b902c60229"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5fb0dbda5764343989884133fc26d5f201c237e148ece3596f859e59d0f8e5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a162109a98d40a23d8c60c026cd0c755fa1ca3f07d0a43a4ffc6f10604e6e255"
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