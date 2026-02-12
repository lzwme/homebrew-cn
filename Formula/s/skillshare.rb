class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.11.8.tar.gz"
  sha256 "9e76770322f7c2629a933a0a21496664258e6ade3205467f2ac81b26fd79e30c"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f2ca5e9509462c1916bcf9fc1fd269cc5a162d9ec1c19ac92ad7aed3b9d1160"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f2ca5e9509462c1916bcf9fc1fd269cc5a162d9ec1c19ac92ad7aed3b9d1160"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f2ca5e9509462c1916bcf9fc1fd269cc5a162d9ec1c19ac92ad7aed3b9d1160"
    sha256 cellar: :any_skip_relocation, sonoma:        "abf3cab3c9e661a63f67dd7b7d8f016e84080bb682d51d811cd785a34c2a2d63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2db5b32978b0a0c183d3b75a25ea64369af95c35fc49b38a4ed499f45db9f61e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a57b5c28dd6945931ff57d72a18cdea60e5e0a0ca1648a9092e21bf25c05cf6"
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