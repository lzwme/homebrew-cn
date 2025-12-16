class Roxctl < Formula
  desc "CLI for Stackrox"
  homepage "https://www.stackrox.io/"
  url "https://ghfast.top/https://github.com/stackrox/stackrox/archive/refs/tags/4.9.2.tar.gz"
  sha256 "cf0dd5764ae49d78ddf5b6c93b140b592edaedb28ba8c41d8ec1c7cdbee20204"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e5045291054946f9f56acef59ad7576f5b6857b0d35c70facf26bcdcd59b6cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb32066bbd16132f6e2ed02cd32de0134c458ce7827eea3f0e85ce061873a81d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f695c5ceb4110063774112aefa22ed65f814d91ae4d2348bcc435c2503e26364"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ef6ad0d3a4ddc0e775b64d9ea001f8ed5200563b89b7738d74bd565281b7c71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1942e330ccef40aa7b186cfb7b34288f38f430dcd61d3b903dc83bf4ba9c1a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67898ca94aa69df8f6fa0288ffa3ef226499917781942e125e1add90c2cb8cf2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./roxctl"

    generate_completions_from_executable(bin/"roxctl", "completion")
  end

  test do
    output = shell_output("#{bin}/roxctl central whoami 2<&1", 1)

    assert_match "please run \"roxctl central login\" to obtain credentials", output
  end
end