class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://ghproxy.com/https://github.com/TomWright/dasel/archive/v2.4.0.tar.gz"
  sha256 "2a36fc5f3d61dd51cbd137ae97fab7ce1fa851d428377c698687c9e17e5bde36"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c1976a90525fea74bde37ab6ee99b7de0d5619b893e6cc655b3b0bc8724db603"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "839fd9b567995eaea40b79118a0f7fedef395e2cd09f05c92542ae061ff38a96"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59d9b4730555e977aec2f7fa85e768428b4320534a520ae3b3767ae4c3496fda"
    sha256 cellar: :any_skip_relocation, sonoma:         "87f2a940bc02a0f8a358830c99df6e27f237298588a37e9f4264c34983db6a5b"
    sha256 cellar: :any_skip_relocation, ventura:        "71cff675dcd3014f518e2c4ef19fdc00250e04a4dc00d951e42f339638928c5c"
    sha256 cellar: :any_skip_relocation, monterey:       "29a3e77f411923144baede0d613165a6779c14833f2737ed0a84b5325f6b8892"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01f29cc251b3cd8aa29fe4a28ec75e97ee835368e9911ee6880b5717440e3d30"
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