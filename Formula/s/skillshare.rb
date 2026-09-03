class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.20.27.tar.gz"
  sha256 "8949741f312e019b8223103017b0efdef3e0b6a1485fd5d1b4ba5966308112d9"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9881bdc7eec56ac7cee70fc503678721a3b2b65321be2f6eb197f26402f330d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9881bdc7eec56ac7cee70fc503678721a3b2b65321be2f6eb197f26402f330d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9881bdc7eec56ac7cee70fc503678721a3b2b65321be2f6eb197f26402f330d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71c5c64aa9db56857b97e7044b9626783fd136931583b7b8b0ffee0e40dfacae"
    sha256 cellar: :any,                 x86_64_linux:  "4c5116a0eb5c00ed5a2ded77bb50edc548c0c95078bfeb225c7fdacd739a465f"
  end

  depends_on "go" => :build

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end