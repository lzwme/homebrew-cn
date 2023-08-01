class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://github.com/replicate/cog"
  url "https://ghproxy.com/https://github.com/replicate/cog/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "3339ea612c9bb22ea6a995720fd20a44d4f22eeba626653a800c283d5ecd885a"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4521af7dafe350c05fe2e8dc8f95e9c1df7bb08d12bc6eb8a69c6ac4a807c83d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22eb076c551a5c865777229763677ab56fab28684d7e575c69c615da68ebee4d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f9825b2ef1c79984a15ee0aa1292db26ca16020027e3e44c794b3d09295da54"
    sha256 cellar: :any_skip_relocation, ventura:        "e2f347ef8f875891a1482b089dde1d5399f865dcf0f362f68e256a407285a88e"
    sha256 cellar: :any_skip_relocation, monterey:       "9bd02f3b8298c47977b965cd55a8876d021ceef81b106fed8089c6ac1f28dac3"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac1c0a4a603a15e051dcd3820aae04aae363c34e6e833f2e64e16c326c2a3d2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "661abb4d0ad87e43ba8a490da45f10036421c857c73129205a4b4eaed48b0cd0"
  end

  depends_on "go" => :build

  uses_from_macos "python" => :build

  def install
    ENV["SETUPTOOLS_SCM_PRETEND_VERSION"] = version.to_s
    system "make", "COG_VERSION=#{version}", "PYTHON=python3"
    bin.install "cog"
    generate_completions_from_executable(bin/"cog", "completion")
  end

  test do
    assert_match "cog version #{version}", shell_output("#{bin}/cog --version")
    assert_match "cog.yaml not found", shell_output("#{bin}/cog build 2>&1", 1)
  end
end