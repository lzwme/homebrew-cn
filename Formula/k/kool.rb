class Kool < Formula
  desc "Web apps development with containers made easy"
  homepage "https://kool.dev"
  url "https://ghfast.top/https://github.com/kool-dev/kool/archive/refs/tags/3.5.2.tar.gz"
  sha256 "b6a49d48ae596eb05aea46fce052744cc8cf10f21753f9224ba339d29a04e1e8"
  license "MIT"
  head "https://github.com/kool-dev/kool.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8c40e986f6c4c6c1c3631702b1616a9df0f2b1f62ccdd3749f503a13edfdbb3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8c40e986f6c4c6c1c3631702b1616a9df0f2b1f62ccdd3749f503a13edfdbb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8c40e986f6c4c6c1c3631702b1616a9df0f2b1f62ccdd3749f503a13edfdbb3"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b043cb0a1b3a010641bb43301f92cca8ef847503c81dbd539d8c68c6b9b6ccf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d2608ed1206d8d0fa0eb11637413658f61ffdba16ee77e4375628eba8526d31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56355058b598afd69012012fb789faa7043649b273459c52c0f13e198ec856bd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X kool-dev/kool/commands.version=#{version}")

    generate_completions_from_executable(bin/"kool", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kool --version")
    assert_match "docker doesn't seem to be installed", shell_output("#{bin}/kool status 2>&1", 1)
  end
end