class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://ghproxy.com/https://github.com/TomWright/dasel/archive/v2.3.3.tar.gz"
  sha256 "1c94d38862308d0610cd9fa251ea70ab9800f35bf5e81d59fb924cd42e23d990"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e36b55b928c22496917853992623837682f1e31e65972d83e3b2672ec45da12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e36b55b928c22496917853992623837682f1e31e65972d83e3b2672ec45da12"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e36b55b928c22496917853992623837682f1e31e65972d83e3b2672ec45da12"
    sha256 cellar: :any_skip_relocation, ventura:        "54b3c4bb06b43953c9ed0330e5d5265dcc24f924533124a0aaa6698cc95c7919"
    sha256 cellar: :any_skip_relocation, monterey:       "54b3c4bb06b43953c9ed0330e5d5265dcc24f924533124a0aaa6698cc95c7919"
    sha256 cellar: :any_skip_relocation, big_sur:        "54b3c4bb06b43953c9ed0330e5d5265dcc24f924533124a0aaa6698cc95c7919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d716af922d532d9f8b479f5a89f9c8c0188d55a6a2dab69877f6a4273dd06ca"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X 'github.com/tomwright/dasel/v2/internal.Version=#{version}'"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/dasel"

    generate_completions_from_executable(bin/"dasel", "completion")
  end

  test do
    assert_equal "\"Tom\"", shell_output("echo '{\"name\": \"Tom\"}' | #{bin}/dasel -r json 'name'").chomp
    assert_match version.to_s, shell_output("#{bin}/dasel --version")
  end
end