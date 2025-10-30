class Roxctl < Formula
  desc "CLI for Stackrox"
  homepage "https://www.stackrox.io/"
  url "https://ghfast.top/https://github.com/stackrox/stackrox/archive/refs/tags/4.8.5.tar.gz"
  sha256 "2ffa4ed0ac799cd4e738a19494c024da125a77c4dba19fa45cc258a7e0ed7512"
  license "Apache-2.0"
  head "https://github.com/stackrox/stackrox.git", branch: "master"

  # Upstream maintains multiple major/minor versions and the "latest" release
  # may be for a lower version, so we have to check multiple releases to
  # identify the highest version.
  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2573358b085354b96994ee26cd4498f8d9664454d478d4636d25798345138b94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80ee7e98d940da9bb1e088da008b0041625751caa5adcd224e04f3ea0ed280e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7014f98794f9710bd54f4961576d3f2995e34af21cda566c5f6b9dc1d4036d8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c954291742ed7aa6136049b4264d203d300f9fb82f00049e98295f92185b7aee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f87792c85e629b9e983b23a2b26dc9c3510ae3056c2af60d4815cb7365c8efc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69e087036c2fce32843cca944b14ca3e8f19c931961c21e01ef7bef339bc50c8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./roxctl"

    generate_completions_from_executable(bin/"roxctl", "completion")
  end

  test do
    output = shell_output("#{bin}/roxctl central whoami 2<&1", 1)
    assert_match <<~EOS, output
      ERROR:	obtaining auth information for localhost:8443: \
      retrieving token: no credentials found for localhost:8443, please run \
      "roxctl central login" to obtain credentials
    EOS
  end
end