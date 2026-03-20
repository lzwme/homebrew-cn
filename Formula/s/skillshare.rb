class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.17.8.tar.gz"
  sha256 "76aca0215c043d1174b3baeae94d0af5e837c4fcdaa6d359e4c59bbbd448d9f5"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e6ad38551e5d4d1163a92aa617e82d0091fa56a02194cd4d9e5e26516a3177e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e6ad38551e5d4d1163a92aa617e82d0091fa56a02194cd4d9e5e26516a3177e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e6ad38551e5d4d1163a92aa617e82d0091fa56a02194cd4d9e5e26516a3177e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1a87a585da8c697f7dac88a3c063e4b9ff5e3f9037c7cce46b9fb9274368ccc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cd60c3301eae8046e15779788ba9d11be718aa5c190eb1179f6696b64c7c595"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca88a50c04c496dc074109077052cd993ed5bdcebe9cd9edca7cbd1dee9d90bb"
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