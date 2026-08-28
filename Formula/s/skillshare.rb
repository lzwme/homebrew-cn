class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.20.26.tar.gz"
  sha256 "eabe0f9fe8ba282bcd72e6b43ae6a50060ca25cf517fd3cb821cb96361da85f2"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd86c0f913455652cc33902bbbf54f81820bc710a4d6f6450862df1149b4f5dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd86c0f913455652cc33902bbbf54f81820bc710a4d6f6450862df1149b4f5dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd86c0f913455652cc33902bbbf54f81820bc710a4d6f6450862df1149b4f5dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "c99df674aebd7e6504e7931bf8d3199958b233cc7b0cec786178072a4d954376"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab1abd6cdb5dc121617bad408236f6b98d36da5f73d6b7696ade2eee914ecc36"
    sha256 cellar: :any,                 x86_64_linux:  "5c530d953de0d1949ee1b22165edeabb1e3bec42c543f7c7a51ce9cff708ace4"
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