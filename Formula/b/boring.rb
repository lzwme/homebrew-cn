class Boring < Formula
  desc "Simple command-line SSH tunnel manager that just works"
  homepage "https://github.com/alebeck/boring"
  url "https://ghfast.top/https://github.com/alebeck/boring/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "b23ce3f9bdb707250b4e138dc059a2b50716e6e310c0d344cf821c4ff150afcf"
  license "MIT"
  head "https://github.com/alebeck/boring.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ecdb262cb1e37df15a49ca89e0ba630a8fdf84b836730d1d6becdcf707eec91a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecdb262cb1e37df15a49ca89e0ba630a8fdf84b836730d1d6becdcf707eec91a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecdb262cb1e37df15a49ca89e0ba630a8fdf84b836730d1d6becdcf707eec91a"
    sha256 cellar: :any_skip_relocation, sonoma:        "36ecd69ba28e5cc60a701e764fdaf3373ca1f6aaac2a9f1e56978c56ffeffcb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f8574a9916db9ea7f9be75fbb5e984f8268a6b6670f7d71ffe71751f79ad80a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d65613883b8ca9fb97bdc35577fe50624e3eccdbbc58e30cfd1eaeaebc19a85e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/alebeck/boring/internal/buildinfo.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/boring"

    generate_completions_from_executable(bin/"boring", "--shell")
  end

  def post_install
    quiet_system "killall", "boring"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/boring version")

    (testpath/(OS.linux? ? ".config/boring" : "")/".boring.toml").write <<~TOML
      [[tunnels]]
      name = "dev"
      local = "9000"
      remote = "localhost:9000"
      host = "dev-server"
    TOML

    assert_match "dev   9000   ->  localhost:9000  dev-server", shell_output("#{bin}/boring list")
  end
end