class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://ghproxy.com/https://github.com/TomWright/dasel/archive/v2.1.2.tar.gz"
  sha256 "0ef6525a3618c24999f8b44f7f65ed94004a393fd73cea4ae7757d7ed55ba485"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "597ccefe5defd916dde132a6f75c79ce0757c96db24d63006caa9331c607e4f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "597ccefe5defd916dde132a6f75c79ce0757c96db24d63006caa9331c607e4f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "597ccefe5defd916dde132a6f75c79ce0757c96db24d63006caa9331c607e4f6"
    sha256 cellar: :any_skip_relocation, ventura:        "5d3b1041ce98395953e941ae05640299b3f63bcd2baf32d956adcc6e96d0805d"
    sha256 cellar: :any_skip_relocation, monterey:       "5d3b1041ce98395953e941ae05640299b3f63bcd2baf32d956adcc6e96d0805d"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d3b1041ce98395953e941ae05640299b3f63bcd2baf32d956adcc6e96d0805d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44100e2b0f77e47a4f60db7534f36d3264725eea17c9a410048a879dc3aed3ff"
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