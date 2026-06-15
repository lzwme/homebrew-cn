class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.20.15.tar.gz"
  sha256 "05aae0c04508aa659551b7a2f2a671ce63dfd66279cc6c9afdb8ed40a0f157db"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "229a2808152b27abb3d73830617138bfb026d7270640b704f51e841a17557714"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "229a2808152b27abb3d73830617138bfb026d7270640b704f51e841a17557714"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "229a2808152b27abb3d73830617138bfb026d7270640b704f51e841a17557714"
    sha256 cellar: :any_skip_relocation, sonoma:        "644472e6fbfeb7cf5632d23583e46d1ba633365fc5180de87e9d0fcea1b7e9c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ba675bc5d9e95533ecae5ddf51dc0446479851ffdaa39088d4694786f7982be"
    sha256 cellar: :any,                 x86_64_linux:  "14b59cc86077c1ba46b5edf26c780a6dcef5a06f715807776207b92f79ca25d5"
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