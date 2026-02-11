class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "78e8bfca0d9f5f4958bff2e5c9d150c889ca12d6c432db3721c187639b3d352f"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93658a7f631ba8f93abb3d8dff55b188f0bc8ed07f976acc9c82d9e942a81b6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93658a7f631ba8f93abb3d8dff55b188f0bc8ed07f976acc9c82d9e942a81b6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93658a7f631ba8f93abb3d8dff55b188f0bc8ed07f976acc9c82d9e942a81b6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a978dd20e82d4a368df19c27b2fcffa187d25769a65e2bb520157e773435abb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6225393be50af7a8407c5764db56494fbbad3c70e6da653d2f0d891efd36929"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e555eb861e4ab58cdc8c1f850ae3ba5ce5d547a91d54484e604af88ef72e171"
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