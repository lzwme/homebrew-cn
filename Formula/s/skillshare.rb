class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.19.20.tar.gz"
  sha256 "72af3af700720e56487839c5f444ff2ef068d2b0a2eff5afae280b6cb7fb1b25"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8563f3f4491b7610610d4643a2ef8d514d8cfd032bc16403b83924c1a7f6795a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8563f3f4491b7610610d4643a2ef8d514d8cfd032bc16403b83924c1a7f6795a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8563f3f4491b7610610d4643a2ef8d514d8cfd032bc16403b83924c1a7f6795a"
    sha256 cellar: :any_skip_relocation, sonoma:        "85f08d9fe839bba70fe81da119bb74b0331ac551a33ae59abb0dcd2f59a244a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03b72d7b80538be407f22b788294e8af72131673ceb72dffa04b79d648285f32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16e185da844cba1fc9d1d226b20bd3a6632528dd5f2bb8d872be39f2abc58d7d"
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