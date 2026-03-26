class Virtctl < Formula
  desc "Allows for using more advanced kubevirt features"
  homepage "https://kubevirt.io/"
  url "https://ghfast.top/https://github.com/kubevirt/kubevirt/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "250de85d0d3ff0c0357c19e21540798a49e986e49e4f4123175a665d026d9c8b"
  license "Apache-2.0"
  head "https://github.com/kubevirt/kubevirt.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32ca7d5e00701f5650d64667fa6bc763596bbb8d31e2e67f50a96a9a712d0c04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a24b5a9e74347a0647f96d464c39ddcc9e40b68631d9f1ca03fc1b3c2da6deaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa9f4323a01bb0d0bc7c670b6b6ea9b8a14ec4a15c64125d65d9b13da8ce0ce5"
    sha256 cellar: :any_skip_relocation, sonoma:        "655552d8440d256e76895231bfb450d57c0f1e026caa2e713cc82b06ab8ec501"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee007d93560cecda1ac6f967bc74a8cf8455d8b38a0959fd4df08d6b65d55636"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2902ac8d0235586922661ee834857170df970cdd0aeda1d2cf6d9fc563a55d1f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X kubevirt.io/client-go/version.gitVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/virtctl"

    generate_completions_from_executable(bin/"virtctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/virtctl version -c")
    assert_match "connection refused", shell_output("#{bin}/virtctl userlist myvm 2>&1", 1)
  end
end